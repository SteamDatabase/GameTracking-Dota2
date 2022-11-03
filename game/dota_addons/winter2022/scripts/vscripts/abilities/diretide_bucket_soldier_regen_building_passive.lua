diretide_bucket_soldier_regen_building_passive = class({})

----------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_diretide_bucket_soldier_regen_building_passive", "modifiers/gameplay/modifier_diretide_bucket_soldier_regen_building_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function diretide_bucket_soldier_regen_building_passive:Precache( context )
	--PrecacheResource( "particle", "particles/hw_fx/candy_fed.vpcf", context )
	--PrecacheResource( "particle", "particles/hw_fx/status_effect_fed.vpcf", context )
end

----------------------------------------------------------------------------------------

function diretide_bucket_soldier_regen_building_passive:GetIntrinsicModifierName()
	return "modifier_diretide_bucket_soldier_regen_building_passive"
end

