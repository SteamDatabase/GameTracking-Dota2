bashy_passive = class({})
LinkLuaModifier( "modifier_bashy_passive", "modifiers/creatures/modifier_bashy_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function bashy_passive:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------


function bashy_passive:Precache( context )
	PrecacheResource( "particle", "particles/creatures/bashy_stack_count.vpcf", context )
end

--------------------------------------------------------------------------------

function bashy_passive:GetIntrinsicModifierName()
	return "modifier_bashy_passive"
end

--------------------------------------------------------------------------------
