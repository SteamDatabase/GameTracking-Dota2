modifier_smashy_passive = class({})

--------------------------------------------------------------------------------

function modifier_smashy_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_smashy_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_smashy_passive:ShouldUseOverheadOffset()
	return true 
end

--------------------------------------------------------------------------------

function modifier_smashy_passive:OnCreated( kv )
	self.bonus_move_speed_pct = self:GetAbility():GetSpecialValueFor( "bonus_move_speed_pct" )
	if IsServer() then 
		self:SetStackCount( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_smashy_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

-----------------------------------------------------------------------------

function modifier_smashy_passive:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetStackCount() == 0 then 
		return 0 
	end

	return self.bonus_move_speed_pct
end

-----------------------------------------------------------------------------

function modifier_smashy_passive:GetActivityTranslationModifiers( params )
	if self:GetStackCount() == 0 then 
		return "" 
	end
	return "super_sprint"
end

