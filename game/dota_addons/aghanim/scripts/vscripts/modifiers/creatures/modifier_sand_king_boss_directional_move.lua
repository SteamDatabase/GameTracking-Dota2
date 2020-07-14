modifier_sand_king_boss_directional_move = class({})

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:OnCreated( kv )
	if IsServer() then
		
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():Interrupt()
	end
end


--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.vMoveDir = nil
		if self:GetAbility():GetAbilityName() == "sand_king_boss_move_left" then
			self.vMoveDir = -self:GetParent():GetRightVector()
		end
		if self:GetAbility():GetAbilityName() == "sand_king_boss_move_right" then
			self.vMoveDir = self:GetParent():GetRightVector()
		end
		if self:GetAbility():GetAbilityName() == "sand_king_boss_move_back" then
			self.vMoveDir = -self:GetParent():GetForwardVector()
		end
		local vNewPos = self:GetParent():GetOrigin() + ( self.vMoveDir * self.speed * dt )
		if not GridNav:CanFindPath( self:GetParent():GetOrigin(), vNewPos ) then
			self:Destroy()
			return
		end
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:GetActivityTranslationModifiers( params )
	if self:GetAbility():GetAbilityName() == "sand_king_boss_move_left" then -- @fixme: GetAbility can be nil here
		return "left"
	end
	if self:GetAbility():GetAbilityName() == "sand_king_boss_move_right" then
		return "right"
	end
	if self:GetAbility():GetAbilityName() == "sand_king_boss_move_back" then
		return "backward"
	end
	return ""
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_directional_move:GetModifierTurnRate_Percentage( params )
	return -90
end
