modifier_invoker_dark_moon_ghost_walk_debuff = class ({})

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk_debuff:GetEffectName( void ) 
	return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk_debuff:GetStatusEffectName( void ) 
	return "particles/status_fx/status_effect_frost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk_debuff:OnCreated( kv )
	self.enemy_slow = self:GetAbility():GetSpecialValueFor( "enemy_slow" )
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.enemy_slow
end