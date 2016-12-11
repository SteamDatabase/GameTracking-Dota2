lina_light_strike_array_lua = class({})
LinkLuaModifier( "modifier_lina_light_strike_array_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_thinker_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function lina_light_strike_array_lua:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------

function lina_light_strike_array_lua:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_lina_light_strike_array_thinker_lua", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




