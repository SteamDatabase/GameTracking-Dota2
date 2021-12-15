
modifier_mine_death_explosion = class({})

--------------------------------------------------------------

function modifier_mine_death_explosion:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_mine_death_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_mine_death_explosion:OnCreated()
	local delay = self:GetAbility():GetSpecialValueFor( "delay_time" )
	--printf( 'min = %f, max = %f\n', min_delay, max_delay )

	EmitSoundOn( "Ability.Bomber.Priming", self:GetParent() )

	self.is_ascension_ability = self:GetAbility():GetSpecialValueFor( "is_ascension_ability" )
	-- Time between warning and detonation
	self:StartIntervalThink( delay )

	if IsServer() then

		if self.is_ascension_ability == 0 then
			self:GetParent():StartGesture( ACT_DOTA_VICTORY )
		else
			local nOverheadFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			self:AddParticle( nOverheadFX, true, false, -1, false, false )
		end

		local radius = self:GetAbility():GetSpecialValueFor( "radius" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( delay, delay, delay ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

---------------------------------------------------------

function modifier_mine_death_explosion:CheckState()
	if self.is_ascension_ability == 1 then
		return {}
	end

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

function modifier_mine_death_explosion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_mine_death_explosion:OnIntervalThink()
	if not IsServer() then
		return
	end
		
	if self:GetAbility() == nil then
		return
	end

	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )

	EmitSoundOn( "Ability.Bomber.Detonate", self:GetParent() )

	local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex2 )

	local nTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	if self.is_ascension_ability == 1 then
		nTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end		

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
				if self.is_ascension_ability == 1 then
					DamageInfo.damage = DamageInfo.damage * entity:GetMaxHealth() / 100.0
					DamageInfo.damage_type = DAMAGE_TYPE_PURE
				end
				ApplyDamage( DamageInfo )
			end
		end
	end

	local targets = Entities:FindAllByClassname( "info_target" )
	if #targets > 0 then
		local vPos = self:GetParent():GetOrigin()
		for _,target in pairs( targets ) do
			local vTargetPos = target:GetAbsOrigin()
			local flDist = ( vTargetPos - vPos ):Length2D()
			if flDist < 200 then
				if target:GetName() == "wall_1_target" then
					local hRelay = Entities:FindByName( nil, "wall_1_relay" )
					hRelay:Trigger( nil, nil )
				elseif target:GetName() == "wall_2_target" then
					local hRelay = Entities:FindByName( nil, "wall_2_relay" )
					hRelay:Trigger( nil, nil )
				elseif target:GetName() == "wall_3_target" then
					local hRelay = Entities:FindByName( nil, "wall_3_relay" )
					hRelay:Trigger( nil, nil )
				elseif target:GetName() == "wall_4_target" then
					local hRelay = Entities:FindByName( nil, "wall_4_relay" )
					hRelay:Trigger( nil, nil )
				elseif target:GetName() == "wall_5_target" then
					local hRelay = Entities:FindByName( nil, "wall_5_relay" )
					hRelay:Trigger( nil, nil )
				end
			end

		end
	end

	if self.is_ascension_ability == 0 then
		self:GetParent():AddEffects( EF_NODRAW )
		self:GetParent():ForceKill( false )
	else
		self:Destroy()
	end

end

--------------------------------------------------------------------------------

function modifier_mine_death_explosion:GetMinHealth( params )
	if IsServer() and self.is_ascension_ability == 0 then
		return 1
	end
	return 0
end 

--------------------------------------------------------------------------------

function modifier_mine_death_explosion:GetModifierModelScale( params )
	if self:GetCaster() == nil then
		return 0
	end

	if self:GetCaster():PassivesDisabled() or self.is_ascension_ability == 1 then
		return 0
	end

	return 25
end

--------------------------------------------------------------------------------
