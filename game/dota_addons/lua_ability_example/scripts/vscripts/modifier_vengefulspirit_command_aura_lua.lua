modifier_vengefulspirit_command_aura_lua = class({})

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:GetModifierAura()
	return "modifier_vengefulspirit_command_aura_effect_lua"
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	if IsServer() and self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:OnDeath( params )
	if IsServer() then
		if self:GetCaster() == nil then
			return 0
		end

		if self:GetCaster():PassivesDisabled() then
			return 0
		end

		if self:GetCaster() ~= self:GetParent() then
			return 0
		end

		local hAttacker = params.attacker
		local hVictim = params.unit

		if hVictim ~= nil and hAttacker ~= nil and hVictim == self:GetCaster() and hAttacker:GetTeamNumber() ~= hVictim:GetTeamNumber() then
			local hAuraHolder = nil
			if hAttacker:IsHero() then
				hAuraHolder = hAttacker
			elseif hAttacker:GetOwnerEntity() ~= nil and hAttacker:GetOwnerEntity():IsHero() then
				hAuraHolder = hAttacker:GetOwnerEntity()
			end

			if hAuraHolder ~= nil then
				hAuraHolder:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_vengefulspirit_command_aura_lua", { duration = -1 } ) 

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAuraHolder )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, hVictim, PATTACH_ABSORIGIN_FOLLOW, nil, hVictim:GetOrigin(), false )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_lua:OnIntervalThink()
	if self:GetCaster() ~= self:GetParent() and self:GetCaster():IsAlive() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------