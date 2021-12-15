
modifier_trap_room_sprint = class({})

--------------------------------------------------------------------------------

function modifier_trap_room_sprint:GetEffectName()
	return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end

--------------------------------------------------------------------------------

function modifier_trap_room_sprint:OnCreated( kv )
	self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_pct" )

	if IsServer() then
		EmitSoundOn( "TrapRoomSprint.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_sprint:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_trap_room_sprint:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_pct
end

--------------------------------------------------------------------------------

function modifier_trap_room_sprint:CheckState()
	local state =
	{
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
