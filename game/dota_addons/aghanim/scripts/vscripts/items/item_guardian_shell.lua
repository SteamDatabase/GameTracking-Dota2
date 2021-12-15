item_guardian_shell = class({})
LinkLuaModifier( "modifier_item_guardian_shell", "modifiers/modifier_item_guardian_shell", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_guardian_shell:GetIntrinsicModifierName()
	return "modifier_item_guardian_shell"
end
