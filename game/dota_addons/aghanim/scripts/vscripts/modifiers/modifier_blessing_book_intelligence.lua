require( "modifiers/modifier_blessing_base" )

modifier_blessing_book_intelligence = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_book_intelligence:GetTexture()
	return "../items/necronomicon"
end

--------------------------------------------------------------------------------

function modifier_blessing_book_intelligence:OnBlessingCreated( kv )
	self.bonus_stat = kv.bonus_stat
end

--------------------------------------------------------------------------------

function modifier_blessing_book_intelligence:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_book_intelligence:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName == "item_book_of_intelligence" or szAbilityName == "item_book_of_greater_intelligence" then
		if szSpecialValueName == "bonus_stat" then
			--print( szAbilityName .. " is asking for " .. szSpecialValueName )
			return 1
		end
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_book_intelligence:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName == "item_book_of_intelligence" or szAbilityName == "item_book_of_greater_intelligence" then
		local szSpecialValueName = params.ability_special_value
		if szSpecialValueName == "bonus_stat" then
			local nSpecialLevel = params.ability_special_level
			local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )

			--print( szAbilityName .. " base value for " .. szSpecialValueName .. " is " .. flBaseValue .. ". Adding " .. self.bonus_stat )

			return flBaseValue + self.bonus_stat
		end
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_book_intelligence:OnTooltip( params )
	return self.bonus_stat
end
