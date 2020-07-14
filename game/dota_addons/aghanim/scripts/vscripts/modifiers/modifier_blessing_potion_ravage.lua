require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_ravage = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_potion_ravage:GetTexture()
	return "../items/river_painter4"
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_ravage:OnBlessingCreated( kv )
	self.duration_percent = kv.duration_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_ravage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_potion_ravage:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_ravage_potion" then
		return 0
	end

	if szSpecialValueName == "duration" then
		--print( 'modifier_blessing_potion_ravage:GetModifierOverrideAbilitySpecial - looking for duration!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_potion_ravage:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_ravage_potion" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "duration" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_blessing_potion_ravage:GetModifierOverrideAbilitySpecialValue - duration_percent is ' .. flBaseValue .. '. Adding on an additional ' .. self.duration_percent )

		return flBaseValue * ( ( 100 + self.duration_percent ) / 100 )
	end

	return 0
end
