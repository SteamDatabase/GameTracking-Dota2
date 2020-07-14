modifier_item_carapace_of_qaldin = class({})

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:OnCreated( kv )
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_mana = self:GetAbility():GetSpecialValueFor( "bonus_mana" )
	self.bonus_restore_pct = self:GetAbility():GetSpecialValueFor( "bonus_restore_pct" )
	self.damage_return_pct = self:GetAbility():GetSpecialValueFor( "damage_return_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:GetModifierHealthBonus( params )
	return self.bonus_hp
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:GetModifierManaBonus( params )
	return self.bonus_mana
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:GetModifierHealAmplify_Percentage( params )
	return self.bonus_restore_pct
end

--------------------------------------------------------------------------------

function modifier_item_carapace_of_qaldin:OnTakeDamage( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end

		local Attacker = params.attacker
		if Attacker ~= nil and Attacker ~= self:GetParent() and Attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local damageInfo = 
			{
				victim = Attacker,
				attacker = self:GetParent(),
				damage = params.damage * self.damage_return_pct / 100,
				damage_type = params.damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
				ability = self:GetAbility(), 
			}
			ApplyDamage( damageInfo )
		end
	end
	return 0
end