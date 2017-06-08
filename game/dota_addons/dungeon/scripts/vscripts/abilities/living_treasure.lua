
living_treasure = class({})
LinkLuaModifier( "modifier_living_treasure", "modifiers/modifier_living_treasure", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_living_treasure_anim_chest", "modifiers/modifier_living_treasure_anim_chest", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function living_treasure:GetIntrinsicModifierName()
	return "modifier_living_treasure"
end
