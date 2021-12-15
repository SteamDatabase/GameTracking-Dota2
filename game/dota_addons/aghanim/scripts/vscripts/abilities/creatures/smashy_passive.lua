smashy_passive = class({})
LinkLuaModifier( "modifier_smashy_passive", "modifiers/creatures/modifier_smashy_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function smashy_passive:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function smashy_passive:GetIntrinsicModifierName()
	return "modifier_smashy_passive"
end

--------------------------------------------------------------------------------
