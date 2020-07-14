spike_trap = class({})

LinkLuaModifier( "modifier_spike_trap_lua", "modifiers/modifier_spike_trap_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spike_trap_thinker_lua", "modifiers/modifier_spike_trap_thinker_lua", LUA_MODIFIER_MOTION_NONE )


function spike_trap:Precache( context )

	PrecacheResource( "particle", "particles/traps/spikes/spiketrap_anticipate.vpcf", context )
	PrecacheResource( "particle", "particles/traps/spikes/spiketrap_anticipate_base.vpcf", context )
	PrecacheResource( "particle", "particles/traps/spikes/spiketrap_pull.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade.vpcf", context )
end


--------------------------------------------------------------------------------

function spike_trap:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

--------------------------------------------------------------------------------

function spike_trap:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_spike_trap_thinker_lua", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




