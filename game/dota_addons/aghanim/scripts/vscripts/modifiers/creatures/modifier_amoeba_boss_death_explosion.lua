
modifier_amoeba_boss_death_explosion = class({})

--------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:OnCreated()
	local min_delay = self:GetAbility():GetSpecialValueFor( "min_delay_time" )
	local max_delay = self:GetAbility():GetSpecialValueFor( "max_delay_time" )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )
	--printf( 'min = %f, max = %f\n', min_delay, max_delay )

	self.unit_count = self:GetAbility():GetSpecialValueFor( "unit_count" ) 
	self.spawn_radius = self:GetAbility():GetSpecialValueFor( "spawn_radius" )
	self.knockback_duration_min = self:GetAbility():GetSpecialValueFor( "knockback_duration_min" )
	self.knockback_duration_max = self:GetAbility():GetSpecialValueFor( "knockback_duration_max" )
	self.knockback_distance_min = self:GetAbility():GetSpecialValueFor( "knockback_distance_min" )
	self.knockback_distance_max = self:GetAbility():GetSpecialValueFor( "knockback_distance_max" )
	self.knockback_height_min = self:GetAbility():GetSpecialValueFor( "knockback_height_min" )
	self.knockback_height_max = self:GetAbility():GetSpecialValueFor( "knockback_height_max" )

	self.unit_type = self:GetAbility():GetSpecialValueFor( "unit_type" )

	self.strUnitName = "npc_dota_creature_amoeba_small"
	if self.unit_type == 0 then
		self.strUnitName = nil
	elseif self.unit_type == 1 then
		self.strUnitName = "npc_dota_creature_amoeba_large"
	elseif self.unit_type == 2 then
		self.strUnitName = "npc_dota_creature_amoeba_medium"
	elseif self.unit_type == 3 then
		self.strUnitName = "npc_dota_creature_amoeba_small"
	else
		print( 'ERROR: unit_type for modifier_amoeba_boss_death_explosion must be 0/1/2/3!' )
	end
	if self.strUnitName then
		print( 'SUMMONED UNIT = ' .. self.strUnitName )
	end

	EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Fuse", self:GetParent() )

	local delay = RandomFloat( min_delay, max_delay )
	self:StartIntervalThink( delay )

	self.nPreviewFX = nil

	if IsServer() then
		self:GetParent():StartGesture( ACT_DOTA_VICTORY )

		local radius = self:GetAbility():GetSpecialValueFor( "radius" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 75, 75, 75 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )		

		local nFXIndex = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( delay, delay, delay ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:GetParent():RemoveAbility( "ability_absolute_no_cc" )
	  	self:GetParent():RemoveModifierByName( "modifier_absolute_no_cc" )
	end
end

---------------------------------------------------------

function modifier_amoeba_boss_death_explosion:CheckState()
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

function modifier_amoeba_boss_death_explosion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:OnIntervalThink()
	if not IsServer() then
		return
	end
		
	if self:GetAbility() == nil then
		return
	end

	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetSpecialValueFor( "explosion_damage" )
	local explosion_slow_duration = self:GetAbility():GetSpecialValueFor( "explosion_slow_duration" )
	local knockback_duration = RandomFloat( self.knockback_duration_min, self.knockback_duration_max )
	local knockback_distance = RandomFloat( self.knockback_distance_min, self.knockback_distance_max )
	local knockback_height = RandomFloat( self.knockback_height_min, self.knockback_height_max )
	print( 'duration: ' .. knockback_duration .. '. distance ' .. knockback_distance .. '. height ' .. knockback_height )

	EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Stun", self:GetParent() )

	--local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", PATTACH_CUSTOMORIGIN, nil )
	--ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
	--ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( radius, radius, radius ) )
	--ParticleManager:ReleaseParticleIndex( nFXIndex2 )

	local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/amoeba_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )		
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )		
	ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )	

	local nTeam = DOTA_UNIT_TARGET_TEAM_ENEMY

	local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, nTeam, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	if #entities > 0 then
		local kv =
		{
			center_x = self:GetParent():GetAbsOrigin().x,
			center_y = self:GetParent():GetAbsOrigin().y,
			center_z = self:GetParent():GetAbsOrigin().z,
			should_stun = true, 
			duration = knockback_duration,
			knockback_duration = knockback_duration,
			knockback_distance = knockback_distance,
			knockback_height = knockback_height,
		}
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

				entity:AddNewModifier( self:GetParent(), self, "modifier_knockback", kv )
				--entity:AddNewModifier( self:GetParent(), self:GetAbility(), 'modifier_acid_blob_explosion_slow', { duration = explosion_slow_duration } )
			end
		end
	end

	--local hDummy = CreateUnitByName( "npc_dota_dummy_caster", self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
	--if hDummy ~= nil then
	--	hDummy.radius = radius
	--	local hAbility = hDummy:AddAbility( "amoeba_boss_death_explosion_thinker" )
	--	hAbility:UpgradeAbility( true )
	--end	

	if self.strUnitName ~= nil then
		local kv =
		{
			center_x = self:GetParent():GetAbsOrigin().x,
			center_y = self:GetParent():GetAbsOrigin().y,
			center_z = self:GetParent():GetAbsOrigin().z,
			should_stun = true, 
			duration = knockback_duration,
			knockback_duration = knockback_duration,
			knockback_distance = knockback_distance,
			knockback_height = knockback_height,
		}

		for i = 1,self.unit_count do
			vSpawnPosition = self:GetParent():GetAbsOrigin() + RandomVector( self.spawn_radius )
			vSpawnPosition = FindPathablePositionNearby( vSpawnPosition, 250, 250 )
			
			vSpawnDirection = vSpawnPosition - self:GetParent():GetAbsOrigin()
			vSpawnDirection = vSpawnDirection:Normalized()
			local angles = VectorAngles( vSpawnDirection )

			local hSplitUnit = CreateUnitByName( self.strUnitName , vSpawnPosition, true, 
				self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )

			hSplitUnit:SetAbsAngles( angles.x, angles.y, angles.z )

			hSplitUnit:AddNewModifier( hSplitUnit, self:GetAbility(), "modifier_aghsfort_amoeba_boss_summoned_knockback", kv )
		end
	end

	self:GetParent():AddEffects( EF_NODRAW )
	self:GetParent():ForceKill( false )

end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:GetMinHealth( params )
	if IsServer() then
		return 1
	end
	return 0
end 

--------------------------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:GetModifierModelScale( params )
	if self:GetCaster() == nil then
		return 0
	end

	return self.model_scale
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_death_explosion:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Alchemist.UnstableConcoction.Fuse", self:GetParent() )	

		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end
	end
end