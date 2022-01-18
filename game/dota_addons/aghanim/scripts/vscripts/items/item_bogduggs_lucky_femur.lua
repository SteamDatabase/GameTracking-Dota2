item_bogduggs_lucky_femur = class({})
LinkLuaModifier( "modifier_item_bogduggs_lucky_femur", "modifiers/modifier_item_bogduggs_lucky_femur", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function item_bogduggs_lucky_femur:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", context )
end


--------------------------------------------------------------------------------

function item_bogduggs_lucky_femur:GetIntrinsicModifierName()
	return "modifier_item_bogduggs_lucky_femur"
end
