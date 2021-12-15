
modifier_acid_blob_death_explosion = class({})

--------------------------------------------------------------

function modifier_acid_blob_death_explosion:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_acid_blob_death_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_acid_blob_death_explosion:OnCreated()
	local min_delay = self:GetAbility():GetSpecialValueFor( "min_delay_time" )
	local max_delay = self:GetAbility():GetSpecialValueFor( "max_delay_time" )
	--printf( 'min = %f, max = %f\n', min_delay, max_delay )

	EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Fuse", self:GetParent() )

	local delay = RandomFloat( min_delay, max_delay )
	self:StartIntervalThink( delay )

	if IsServer() then

		self:GetParent():StartGesture( ACT_DOTA_VICTORY )

		local radius = self:GetAbility():GetSpecialValueFor( "radius" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( delay, delay, delay ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

---------------------------------------------------------

function modifier_acid_blob_death_explosion:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------

function modifier_acid_blob_death_explosion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_acid_blob_death_explosion:OnIntervalThink()
	if not IsServer() then
		return
	end
		
	if self:GetAbility() == nil then
		return
	end

	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "explosion_damage" )
	local explosion_slow_duration = self:GetAbility():GetSpecialValueFor( "explosion_slow_duration" )

	EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Stun", self:GetParent() )

	--local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", PATTACH_CUSTOMORIGIN, nil )
	--ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
	--ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( radius, radius, radius ) )
	--ParticleManager:ReleaseParticleIndex( nFXIndex2 )

	local nTeam = DOTA_UNIT_TARGET_TEAM_ENEMY

	local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, nTeam, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	if #entities > 0 then
		for _,entity in pairs(entities) do
			if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and ( not entity:IsMagicImmune() ) and ( not entity:IsInvulnerable() ) then
				local DamageInfo =
				{
					victim = entity,
					attacker = self:GetCaster(),
					ability = self,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage( DamageInfo )

				entity:AddNewModifier( self:GetParent(), self:GetAbility(), 'modifier_acid_blob_explosion_slow', { duration = explosion_slow_duration } )
			end
		end
	end

	local hDummy = CreateUnitByName( "npc_dota_dummy_caster", self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
	if hDummy ~= nil then
		hDummy.radius = radius
		local hAbility = hDummy:AddAbility( "acid_blob_death_explosion_thinker" )
		hAbility:UpgradeAbility( true )
	end	

	self:GetParent():AddEffects( EF_NODRAW )
	self:GetParent():ForceKill( false )

end

--------------------------------------------------------------------------------

function modifier_acid_blob_death_explosion:GetMinHealth( params )
	if IsServer() then
		return 1
	end
	return 0
end 

--------------------------------------------------------------------------------

function modifier_acid_blob_death_explosion:GetModifierModelScale( params )
	if self:GetCaster() == nil then
		return 0
	end

	return 50
end

--------------------------------------------------------------------------------

function modifier_acid_blob_death_explosion:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Alchemist.UnstableConcoction.Fuse", self:GetParent() )	
	end
end