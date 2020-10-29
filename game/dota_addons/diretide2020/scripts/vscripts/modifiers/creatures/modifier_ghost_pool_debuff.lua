
modifier_ghost_pool_debuff = class({})

--------------------------------------------------------------------------------

function modifier_ghost_pool_debuff:OnCreated( kv )
	if IsServer() then
		if not self:GetAbility() then
			self:Destroy()
			return
		end

		self.movement_speed_slow = self:GetAbility():GetSpecialValueFor( "movement_speed_slow" )
		self.attack_speed_slow = self:GetAbility():GetSpecialValueFor( "attack_speed_slow" )
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_ghost_pool_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_speed_slow
end

-----------------------------------------------------------------------------

function modifier_ghost_pool_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_slow
end

-----------------------------------------------------------------------------

--[[
function modifier_ghost_pool_debuff:CheckState()
	local state =
	{
		[ MODIFIER_STATE_MUTED ] = true,
	}

	return state
end
]]

-----------------------------------------------------------------------------
