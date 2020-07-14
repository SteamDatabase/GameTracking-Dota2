modifier_sand_king_boss_sandstorm_effect = class({})

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm_effect:OnCreated( kv )
	self.movespeed_pct = self:GetAbility():GetSpecialValueFor( "movespeed_pct" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.blind_duration = self:GetAbility():GetSpecialValueFor( "blind_duration" )
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm_effect:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm_effect:CheckState()
	local state =
	{
	}
	return state
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm_effect:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.movespeed_pct
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm_effect:OnIntervalThink()
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

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_sandstorm_effect:OnDestroy()
	if IsServer() then
		--self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sand_king_boss_sandstorm_blind", { duration = self.blind_duration } )
	end
end