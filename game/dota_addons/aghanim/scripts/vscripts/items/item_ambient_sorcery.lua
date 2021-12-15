
item_ambient_sorcery = class({})
LinkLuaModifier( "modifier_item_ambient_sorcery", "modifiers/modifier_item_ambient_sorcery", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ambient_sorcery_effect", "modifiers/modifier_item_ambient_sorcery_effect", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function item_ambient_sorcery:GetIntrinsicModifierName()
	return "modifier_item_ambient_sorcery"
end
