require( "modifiers/modifier_blessing_base" )

modifier_blessing_potion_echo_slam = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_potion_echo_slam:OnBlessingCreated( kv )
	self.echo_slam_echo_damage_percent = kv.echo_slam_echo_damage_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_potion_echo_slam:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_potion_echo_slam:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_echo_slam_potion" then
		return 0
	end

	if szSpecialValueName == "echo_slam_echo_damage" then
		--print( 'modifier_blessing_potion_echo_slam:GetModifierOverrideAbilitySpecial - looking for echo_slam_echo_damage!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_potion_echo_slam:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_echo_slam_potion" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "echo_slam_echo_damage" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_blessing_potion_echo_slam:GetModifierOverrideAbilitySpecialValue - echo_slam_echo_damage is ' .. flBaseValue .. '. Adding on an additional ' .. self.echo_slam_echo_damage_percent )

		return flBaseValue * ( ( 100 + self.echo_slam_echo_damage_percent ) / 100 )
	end

	return 0
end
