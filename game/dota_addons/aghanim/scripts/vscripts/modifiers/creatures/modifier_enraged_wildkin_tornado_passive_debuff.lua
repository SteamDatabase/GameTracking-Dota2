modifier_enraged_wildkin_tornado_passive_debuff = class({})

-----------------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive_debuff:OnCreated( kv )
	self.movespeed_pct = self:GetAbility():GetSpecialValueFor( "movespeed_pct" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

-----------------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end


-----------------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.movespeed_pct
end

-----------------------------------------------------------------------------------------

function modifier_enraged_wildkin_tornado_passive_debuff:OnIntervalThink()
	if IsServer() then
		if self:GetParent() and self:GetParent():IsInvulnerable() == false then
	
			local damageInfo = 
			{
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.damage / 2,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility()
			}

			ApplyDamage( damageInfo )
		end
	end
end

