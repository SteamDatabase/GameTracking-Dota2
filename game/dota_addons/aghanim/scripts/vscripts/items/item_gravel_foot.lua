item_gravel_foot = class({})
LinkLuaModifier( "modifier_item_gravel_foot", "modifiers/modifier_item_gravel_foot", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_gravel_foot:GetIntrinsicModifierName()
	return "modifier_item_gravel_foot"
end
