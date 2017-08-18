modifier_ice_boss_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:OnCreated( kv )

	if IsServer() then
		for k, v in pairs(kv) do
			if k == "bonus_damage_pct_per_egg" then
				self.bonus_damage_pct_per_egg = v
			elseif k == "damage_reduction_per_egg" then
				self.damage_reduction_per_egg = v
			end
		end
	end

end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	if IsServer() then
	end
	return state
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end
----------------------------------------

function modifier_ice_boss_passive:GetModifierDamageOutgoing_Percentage( params )
	return self.bonus_damage_pct_per_egg * self:GetCaster().numEggsAlive
end

----------------------------------------

function modifier_ice_boss_passive:GetModifierIncomingDamage_Percentage( params )
	return -self.damage_reduction_per_egg * self:GetCaster().numEggsAlive
end