
spike_trap_ability = class({})
LinkLuaModifier( "modifier_spike_trap", "modifiers/modifier_spike_trap", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spike_trap_thinker", "modifiers/modifier_spike_trap_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spike_trap_ability:GetAOERadius()
	return self:GetSpecialValueFor( "trap_radius" )
end

--------------------------------------------------------------------------------

function spike_trap_ability:OnSpellStart()
	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_spike_trap_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------

