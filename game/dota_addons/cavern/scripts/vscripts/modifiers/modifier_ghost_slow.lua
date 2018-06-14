
modifier_ghost_slow = class({})

--------------------------------------------------------------------------------

function modifier_ghost_slow:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ghost_slow:GetStatusEffectName()  
	return "particles/status_fx/status_effect_repel.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ghost_slow:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_ghost_slow:OnCreated( kv )
	if self:GetAbility() == nil then
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end

		return
	end

	self.base_move_slow = self:GetAbility():GetSpecialValueFor( "base_move_slow" )
	self.move_slow_per_stack = self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
end

--------------------------------------------------------------------------------

function modifier_ghost_slow:OnRefresh( kv )
	if self:GetAbility() == nil then
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end

		return
	end

	self.base_move_slow = self:GetAbility():GetSpecialValueFor( "base_move_slow" )
	self.move_slow_per_stack = self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
end

--------------------------------------------------------------------------------

function modifier_ghost_slow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.base_move_slow - ( self.move_slow_per_stack * self:GetStackCount() )
end

--------------------------------------------------------------------------------
