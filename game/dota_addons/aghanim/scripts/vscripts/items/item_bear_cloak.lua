
item_bear_cloak = class({})
LinkLuaModifier( "modifier_item_bear_cloak", "modifiers/modifier_item_bear_cloak", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_bear_cloak_effect", "modifiers/modifier_item_bear_cloak_effect", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_bear_cloak:GetIntrinsicModifierName()
	return "modifier_item_bear_cloak"
end
