require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_arcanist = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_potion_arcanist:OnBlessingCreated( kv )
	self.cooldown_reduction_percent = kv.cooldown_reduction_percent
	self.manacost_reduction_percent = kv.manacost_reduction_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_arcanist:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_potion_arcanist:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_arcanist_potion" then
		return 0
	end

	if szSpecialValueName == "cooldown_reduction_pct" or szSpecialValueName == "manacost_reduction_pct" then
		print( 'modifier_blessing_potion_arcanist:GetModifierOverrideAbilitySpecial - looking for cooldown_reduction_pct or manacost_reduction_pct!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_potion_arcanist:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_arcanist_potion" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "cooldown_reduction_pct" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		print( 'modifier_blessing_potion_arcanist:GetModifierOverrideAbilitySpecialValue - cooldown_reduction_pct is ' .. flBaseValue .. '. Adding on an additional ' .. self.cooldown_reduction_percent )

		return flBaseValue * ( ( 100 + self.cooldown_reduction_percent ) / 100 )
	elseif szSpecialValueName == "manacost_reduction_pct" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		print( 'modifier_blessing_potion_arcanist:GetModifierOverrideAbilitySpecialValue - manacost_reduction_pct is ' .. flBaseValue .. '. Adding on an additional ' .. self.manacost_reduction_percent )

		return flBaseValue * ( ( 100 + self.manacost_reduction_percent ) / 100 )
	end

	return 0
end
