modifier_item_sign_of_the_arachnid = class({})

--------------------------------------------------------------------------------

function modifier_item_sign_of_the_arachnid:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_sign_of_the_arachnid:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:IsAura()
	return true
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:GetModifierAura()
	return  "modifier_item_sign_of_the_arachnid_effect"
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:GetAuraRadius()
	return self.radius
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.bonus_agility = self:GetAbility():GetSpecialValueFor( "bonus_agility" )
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_sign_of_the_arachnid:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end


