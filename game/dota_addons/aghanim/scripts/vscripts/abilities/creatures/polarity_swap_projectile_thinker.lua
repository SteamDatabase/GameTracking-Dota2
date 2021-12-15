
polarity_swap_projectile_thinker = class({})
LinkLuaModifier( "modifier_polarity_swap_projectile_thinker", "modifiers/creatures/modifier_polarity_swap_projectile_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function polarity_swap_projectile_thinker:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf", context )
end

-----------------------------------------------------------------------------------------

function polarity_swap_projectile_thinker:GetIntrinsicModifierName()
	return "modifier_polarity_swap_projectile_thinker"
end

-----------------------------------------------------------------------------------------

function polarity_swap_projectile_thinker:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		print( 'projectile hit ' .. hTarget:GetUnitName() )
		if hTarget ~= nil then
			local hBuff = hTarget:FindModifierByName( 'modifier_polarity' )
			if hBuff then
				hBuff:SwapPolarity()
			end
		end
	end

	return true
end
