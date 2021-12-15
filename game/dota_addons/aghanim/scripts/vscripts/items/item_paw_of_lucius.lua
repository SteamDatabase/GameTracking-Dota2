item_paw_of_lucius = class({})
LinkLuaModifier( "modifier_item_paw_of_lucius", "modifiers/modifier_item_paw_of_lucius", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_paw_of_lucius:GetIntrinsicModifierName()
	return "modifier_item_paw_of_lucius"
end

--------------------------------------------------------------------------------

function item_paw_of_lucius:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", context )
end
