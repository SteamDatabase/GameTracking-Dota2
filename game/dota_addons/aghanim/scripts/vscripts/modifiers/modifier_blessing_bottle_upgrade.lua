require( "modifiers/modifier_blessing_base" )

modifier_blessing_bottle_upgrade = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:GetTexture()
	return "../items/bottle"
end

--------------------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	if params.ability:GetAbilityName() == "item_bottle" and params.ability_special_value == "max_charges" then
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:GetModifierOverrideAbilitySpecialValue( params )
	if params.ability:GetAbilityName() == "item_bottle" and params.ability_special_value == "max_charges" then
		local nSpecialLevel = params.ability_special_level
		return params.ability:GetLevelSpecialValueNoOverride( "max_charges", nSpecialLevel ) + self:GetStackCount()
	end

	return 0
end
