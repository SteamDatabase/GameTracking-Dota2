invoker_dark_moon_ghost_walk = class({})
LinkLuaModifier( "modifier_invoker_dark_moon_ghost_walk", "modifiers/modifier_invoker_dark_moon_ghost_walk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_dark_moon_ghost_walk_debuff", "modifiers/modifier_invoker_dark_moon_ghost_walk_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function invoker_dark_moon_ghost_walk:GetIntrinsicModifierName()
	return "modifier_invoker_dark_moon_ghost_walk"
end

--------------------------------------------------------------------------------

function invoker_dark_moon_ghost_walk:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local kv =
		{
			duration = self:GetSpecialValueFor( "lift_duration" ),
			land_damage = self:GetSpecialValueFor( "land_damage" ),
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_invoker_tornado", kv )
	end

	return false
end

--------------------------------------------------------------------------------