require( "modifiers/modifier_blessing_base" )

modifier_blessing_bottle_upgrade = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:GetTexture()
	return "../items/bottle"
end

--------------------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:OnBlessingCreated( kv )
	self.max_charges = kv.max_charges
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

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_bottle" then
		return 0
	end

	if szSpecialValueName == "max_charges" then
		--print( 'modifier_blessing_bottle_upgrade:GetModifierOverrideAbilitySpecial - looking for max_charges!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_bottle_upgrade:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_bottle" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "max_charges" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_blessing_bottle_upgrade:GetModifierOverrideAbilitySpecialValue - max_charges is ' .. flBaseValue .. '. Adding on an additional ' .. self.max_charges )

		return flBaseValue + self.max_charges
	end

	return 0
end
