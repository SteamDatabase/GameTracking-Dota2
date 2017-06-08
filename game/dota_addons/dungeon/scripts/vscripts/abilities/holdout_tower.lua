
holdout_tower = class({})
LinkLuaModifier( "modifier_holdout_tower", "modifiers/modifier_holdout_tower", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function holdout_tower:GetIntrinsicModifierName()
	return "modifier_holdout_tower"
end

--------------------------------------------------------------------------------
