modifier_vengefulspirit_command_aura_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:IsDebuff()
	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:OnCreated( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:OnRefresh( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
end


--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_vengefulspirit_command_aura_effect_lua:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		return -self.bonus_damage_pct
	end

	return self.bonus_damage_pct
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

