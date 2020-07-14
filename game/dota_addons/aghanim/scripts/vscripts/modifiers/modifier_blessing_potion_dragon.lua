require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_dragon = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_potion_dragon:OnBlessingCreated( kv )
	self.bonus_attack_damage_percent = kv.bonus_attack_damage_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_dragon:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_potion_dragon:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_dragon_potion" then
		return 0
	end

	if szSpecialValueName == "bonus_attack_damage" then
		--print( 'modifier_blessing_potion_dragon:GetModifierOverrideAbilitySpecial - looking for ' .. szSpecialValueName )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_potion_dragon:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_dragon_potion" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "bonus_attack_damage" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_blessing_potion_dragon:GetModifierOverrideAbilitySpecialValue - bonus_attack_damage is ' .. flBaseValue .. '. Adding on an additional ' .. self.bonus_attack_damage_percent )

		return flBaseValue * ( ( 100 + self.bonus_attack_damage_percent ) / 100 )
	end

	return 0
end
