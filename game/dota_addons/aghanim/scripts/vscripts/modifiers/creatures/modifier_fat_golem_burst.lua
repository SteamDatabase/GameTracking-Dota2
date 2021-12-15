
modifier_fat_golem_burst = class({})

-----------------------------------------------------------------------------------------

function modifier_fat_golem_burst:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_fat_golem_burst:OnCreated( kv )
	if not IsServer() then
		return
	end

	self.thinker_duration = self:GetAbility():GetSpecialValueFor( "thinker_duration" )
	self.burst_radius = self:GetAbility():GetSpecialValueFor( "burst_radius" )
	self.debuff_duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
end

--------------------------------------------------------------------------------

function modifier_fat_golem_burst:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_fat_golem_burst:OnDeath( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			self:DoBurst()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_fat_golem_burst:DoBurst()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.burst_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_fat_golem_burst_debuff", { duration = self.debuff_duration } )
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.burst_radius, self.burst_radius, self.burst_radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( self.burst_radius, 1, 1 ) )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )

		EmitSoundOn( "FatGolem.Burst", self:GetCaster() )

		EmitSoundOn( "FatGolem.Burst.Silence", self:GetCaster() )

		CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_fat_golem_burst_thinker", { duration = self.thinker_duration }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
	end	
end

--------------------------------------------------------------------------------
