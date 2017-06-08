soldier_cage = class({})
LinkLuaModifier( "modifier_soldier_cage", "modifiers/modifier_soldier_cage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_soldier_cage_open", "modifiers/modifier_soldier_cage_open", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function soldier_cage:GetIntrinsicModifierName()
	return "modifier_soldier_cage"
end

--------------------------------------------------------------------------------
