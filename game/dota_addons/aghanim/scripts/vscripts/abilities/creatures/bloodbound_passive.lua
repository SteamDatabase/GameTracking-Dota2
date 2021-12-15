
bloodbound_passive = class({})
LinkLuaModifier( "modifier_bloodbound", "modifiers/creatures/modifier_bloodbound", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function bloodbound_passive:Precache( context )
	PrecacheResource( "particle", "particles/gameplay/bloodbound_cast.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/bloodbound_arc.vpcf", context )
end

--------------------------------------------------------------------------------

function bloodbound_passive:GetIntrinsicModifierName()
	return "modifier_bloodbound"
end

--------------------------------------------------------------------------------

