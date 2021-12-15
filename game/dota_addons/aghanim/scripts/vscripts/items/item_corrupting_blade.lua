
item_corrupting_blade = class({})
LinkLuaModifier( "modifier_item_corrupting_blade", "modifiers/modifier_item_corrupting_blade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_corrupting_blade_buff", "modifiers/modifier_item_corrupting_blade_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_corrupting_blade:GetIntrinsicModifierName()
	return "modifier_item_corrupting_blade"
end
