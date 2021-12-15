modifier_item_longclaws_amulet = class({})

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:OnCreated( kv )
	self.spell_lifesteal_pct = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_pct" )
	self.cooldown_reduction_pct = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_pct" )
	self.mana_cost_reduction_pct = self:GetAbility():GetSpecialValueFor( "mana_cost_reduction_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_UNIT_STATS_NEEDS_REFRESH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:GetModifierPercentageCooldown( params )
	return self.cooldown_reduction_pct
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:GetModifierPercentageManacost( params )
	return self.mana_cost_reduction_pct
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:GetModifierUnitStatsNeedsRefresh( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_item_longclaws_amulet:OnTakeDamage( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Ability == nil or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local flLifesteal = flDamage * self.spell_lifesteal_pct / 100
		Attacker:HealWithParams( flLifesteal, self:GetAbility(), false, true, self:GetCaster(), true )
	end
	return 0
end

