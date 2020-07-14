require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_shadow_wave = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_potion_shadow_wave:OnBlessingCreated( kv )
	self.damage_percent = kv.damage_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_shadow_wave:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_potion_shadow_wave:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_shadow_wave_effect_potion" then
		return 0
	end

	if szSpecialValueName == "damage" then
		--print( 'modifier_blessing_potion_shadow_wave:GetModifierOverrideAbilitySpecial - looking for damage!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_potion_shadow_wave:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_shadow_wave_effect_potion" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "damage" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_blessing_potion_shadow_wave:GetModifierOverrideAbilitySpecialValue - damage is ' .. flBaseValue .. '. Adding on an additional ' .. self.damage_percent )

		return flBaseValue * ( ( 100 + self.damage_percent ) / 100 )
	end

	return 0
end
