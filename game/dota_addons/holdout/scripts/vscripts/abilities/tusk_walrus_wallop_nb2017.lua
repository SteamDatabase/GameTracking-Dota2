tusk_walrus_wallop_nb2017 = class({})
LinkLuaModifier( "modifier_tusk_walrus_wallop_nb2017", "modifiers/modifier_tusk_walrus_wallop_nb2017", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tusk_walrus_wallop_enemy_nb2017", "modifiers/modifier_tusk_walrus_wallop_enemy_nb2017", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function tusk_walrus_wallop_nb2017:GetIntrinsicModifierName()
	return "modifier_tusk_walrus_wallop_nb2017"
end

--------------------------------------------------------------------------------

function tusk_walrus_wallop_nb2017:GetCastRange( vLocation, hTarget )
	
	return self:GetCaster():Script_GetAttackRange()
end

--------------------------------------------------------------------------------
