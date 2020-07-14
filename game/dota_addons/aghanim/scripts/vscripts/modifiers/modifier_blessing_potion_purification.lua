require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_purification = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_potion_purification:GetTexture()
	return "../items/river_painter4"
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_purification:OnBlessingCreated( kv )
	self.radius_percent = kv.radius_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_purification:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_potion_purification:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_purification_potion" then
		return 0
	end

	if szSpecialValueName == "radius" then
		--print( 'modifier_blessing_potion_purification:GetModifierOverrideAbilitySpecial - looking for radius!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_potion_purification:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_purification_potion" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "radius" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_blessing_potion_purification:GetModifierOverrideAbilitySpecialValue - radius is ' .. flBaseValue .. '. Adding on an additional ' .. self.radius_percent )

		return flBaseValue * ( ( 100 + self.radius_percent ) / 100 )
	end

	return 0
end
