require( "modifiers/modifier_blessing_base" )

modifier_blessing_health_boost = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_health_boost:OnBlessingCreated( kv )
	self.bonus_health_per_level = kv.bonus_health_per_level
end

--------------------------------------------------------------------------------

function modifier_blessing_health_boost:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_health_boost:GetModifierHealthBonus( params )
	if self:GetParent() ~= nil and self:GetParent():IsNull() == false then
		local nHealthBoost = self.bonus_health_per_level * self:GetParent():GetLevel()
		--print( 'modifier_blessing_health_boost:GetModifierHealthBonus - bonus is ' .. nHealthBoost )
		return nHealthBoost
	end

	print( 'WARNING: modifier_blessing_health_boost:GetModifierHealthBonus - parent not found - returning 0' )
	return 0
end
