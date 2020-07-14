
modifier_item_ambient_sorcery = class({})

--------------------------------------------------------------------------------

function modifier_item_ambient_sorcery:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_ambient_sorcery:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_ambient_sorcery:IsAura()
	return true
end

----------------------------------------

function modifier_item_ambient_sorcery:GetModifierAura()
	return  "modifier_item_ambient_sorcery_effect"
end

----------------------------------------

function modifier_item_ambient_sorcery:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

----------------------------------------

function modifier_item_ambient_sorcery:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_item_ambient_sorcery:GetAuraRadius()
	return self.radius
end

----------------------------------------

function modifier_item_ambient_sorcery:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
end

----------------------------------------

function modifier_item_ambient_sorcery:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

----------------------------------------

function modifier_item_ambient_sorcery:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end


