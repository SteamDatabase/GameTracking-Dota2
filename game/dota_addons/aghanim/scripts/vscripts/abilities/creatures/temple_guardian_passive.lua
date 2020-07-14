
temple_guardian_passive = class({})
LinkLuaModifier( "modifier_temple_guardian_passive", "modifiers/creatures/modifier_temple_guardian_passive", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function temple_guardian_passive:GetIntrinsicModifierName()
	return "modifier_temple_guardian_passive"
end

-----------------------------------------------------------------------------------------
