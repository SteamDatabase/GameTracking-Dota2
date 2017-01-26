warlock_hp_aura = class({})
LinkLuaModifier( "modifier_warlock_hp_aura", "modifiers/modifier_warlock_hp_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warlock_hp_aura_effect", "modifiers/modifier_warlock_hp_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function warlock_hp_aura:GetIntrinsicModifierName()
	return "modifier_warlock_hp_aura"
end

--------------------------------------------------------------------------------
