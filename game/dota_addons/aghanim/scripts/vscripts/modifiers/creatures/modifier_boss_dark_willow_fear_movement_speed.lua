modifier_boss_dark_willow_fear_movement_speed = class( {} )

--------------------------------------------------------------------------------------

function modifier_boss_dark_willow_fear_movement_speed:IsHidden()
	return true 
end

--------------------------------------------------------------------------------------

function modifier_boss_dark_willow_fear_movement_speed:OnCreated( kv )
	self.movement_speed_pct = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
end

--------------------------------------------------------------------------------------

function modifier_boss_dark_willow_fear_movement_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------------


function modifier_boss_dark_willow_fear_movement_speed:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_speed_pct
end