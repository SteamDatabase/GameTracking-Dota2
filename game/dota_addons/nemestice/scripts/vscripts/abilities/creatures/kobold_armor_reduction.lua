
kobold_armor_reduction = class({})

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_kobold_armor_reduction", "modifiers/creatures/modifier_kobold_armor_reduction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kobold_armor_reduction_debuff", "modifiers/creatures/modifier_kobold_armor_reduction_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kobold_armor_reduction_counter", "modifiers/creatures/modifier_kobold_armor_reduction_counter", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function kobold_armor_reduction:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
end

--------------------------------------------------------------------------------

function kobold_armor_reduction:GetIntrinsicModifierName()
	return "modifier_kobold_armor_reduction"
end

--------------------------------------------------------------------------------
