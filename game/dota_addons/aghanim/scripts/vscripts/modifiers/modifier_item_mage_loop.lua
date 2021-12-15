modifier_item_mage_loop = class({})

--------------------------------------------------------------------------------

function modifier_item_mage_loop:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_mage_loop:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_mage_loop:OnCreated( kv )
	self.manasteal_pct = self:GetAbility():GetSpecialValueFor( "manasteal_pct" )
	self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
end

--------------------------------------------------------------------------------

function modifier_item_mage_loop:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_mage_loop:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end


--------------------------------------------------------------------------------

function modifier_item_mage_loop:OnAttacked( params )
	if IsServer() then
		if params.attacker == self:GetParent() and params.target ~= nil then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items/mage_loop_restore_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local flManasteal = params.damage * self.manasteal_pct / 100
			self:GetParent():GiveMana( flManasteal )
		end
	end

	return 1
end

--------------------------------------------------------------------------------

function modifier_item_mage_loop:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end 

