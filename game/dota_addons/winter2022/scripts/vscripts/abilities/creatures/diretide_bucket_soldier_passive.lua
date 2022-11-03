diretide_bucket_soldier_passive = class({})

----------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_diretide_bucket_soldier_passive", "modifiers/creatures/modifier_diretide_bucket_soldier_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function diretide_bucket_soldier_passive:Precache( context )
	PrecacheResource( "particle", "particles/units/creatures/bucket_guardian/bucket_guardian_ambient.vpcf", context )
end

-----------------------------------------------------------------------------------------

function diretide_bucket_soldier_passive:GetIntrinsicModifierName()
	return "modifier_diretide_bucket_soldier_passive"
end

