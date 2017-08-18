treant_leech_seed_nb2017 = class({})
LinkLuaModifier( "modifier_treant_leech_seed_nb2017", "modifiers/modifier_treant_leech_seed_nb2017", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function treant_leech_seed_nb2017:GetIntrinsicModifierName()
	return "modifier_treant_leech_seed_nb2017"
end

--------------------------------------------------------------------------------

function treant_leech_seed_nb2017:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
	end

	hTarget:Heal( self:GetSpecialValueFor( "leech_damage" ), self )
	return true 
end