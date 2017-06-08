
fake_treasure_chest = class({})
LinkLuaModifier( "modifier_fake_treasure_chest", "modifiers/modifier_fake_treasure_chest", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function fake_treasure_chest:GetIntrinsicModifierName()
	return "modifier_fake_treasure_chest"
end

--------------------------------------------------------------------------------
