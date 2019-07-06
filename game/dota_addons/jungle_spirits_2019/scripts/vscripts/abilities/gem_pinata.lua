
gem_pinata = class({})

LinkLuaModifier( "modifier_gem_pinata", "modifiers/modifier_gem_pinata", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gem_pinata:GetIntrinsicModifierName()
	return "modifier_gem_pinata"
end

--------------------------------------------------------------------------------
