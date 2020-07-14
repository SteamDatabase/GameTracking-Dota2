
treasure_chest = class({})
LinkLuaModifier( "modifier_treasure_chest", "modifiers/modifier_treasure_chest", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function treasure_chest:GetIntrinsicModifierName()
	return "modifier_treasure_chest"
end

--------------------------------------------------------------------------------
