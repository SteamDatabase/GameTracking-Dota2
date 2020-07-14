modifier_item_unhallowed_icon = class({})

--------------------------------------------------------------------------------

function modifier_item_unhallowed_icon:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_unhallowed_icon:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_unhallowed_icon:IsAura()
	return true
end

----------------------------------------

function modifier_item_unhallowed_icon:GetModifierAura()
	return  "modifier_item_unhallowed_icon_effect"
end

----------------------------------------

function modifier_item_unhallowed_icon:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

----------------------------------------

function modifier_item_unhallowed_icon:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_item_unhallowed_icon:GetAuraRadius()
	return self.radius
end

----------------------------------------

function modifier_item_unhallowed_icon:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
end

----------------------------------------

function modifier_item_unhallowed_icon:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_unhallowed_icon:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end


