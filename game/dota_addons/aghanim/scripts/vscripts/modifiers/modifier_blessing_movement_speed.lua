require( "modifiers/modifier_blessing_base" )

modifier_blessing_movement_speed = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_movement_speed:OnBlessingCreated( kv )
	self.bonus_movement_speed = kv.bonus_movement_speed
end

--------------------------------------------------------------------------------

function modifier_blessing_movement_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_movement_speed:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movement_speed
end



--------------------------------------------------------------------------------
function modifier_blessing_movement_speed:IsPermanent()
	return true
end