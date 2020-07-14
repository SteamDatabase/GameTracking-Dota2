require( "modifiers/modifier_blessing_base" )

modifier_blessing_refresher_shard = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_refresher_shard:GetTexture()
	return "../items/river_painter4"
end

--------------------------------------------------------------------------------

function modifier_blessing_refresher_shard:OnBlessingCreated( kv )
	self.health_restore_percent = kv.health_restore_percent
end

--------------------------------------------------------------------------------

function modifier_blessing_refresher_shard:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_blessing_refresher_shard:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "item_aghsfort_refresher_shard" then
		return 0
	end

	if szSpecialValueName == "health_restore_percent" then
		print( 'modifier_blessing_refresher_shard:GetModifierOverrideAbilitySpecial - looking for health_restore_percent!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_blessing_refresher_shard:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "item_aghsfort_refresher_shard" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "health_restore_percent" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		print( 'modifier_blessing_refresher_shard:GetModifierOverrideAbilitySpecialValue - health_restore_percent is ' .. flBaseValue .. '. Adding on an additional ' .. self.health_restore_percent )

		return flBaseValue + self.health_restore_percent
	end

	return 0
end
