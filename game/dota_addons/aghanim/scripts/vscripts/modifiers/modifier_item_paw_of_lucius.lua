modifier_item_paw_of_lucius = class({})

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:OnCreated( kv )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.rupture_chance = self:GetAbility():GetSpecialValueFor( "rupture_chance" )
	self.rupture_duration = self:GetAbility():GetSpecialValueFor( "rupture_duration" )
end

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

--------------------------------------------------------------------------------

function modifier_item_paw_of_lucius:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and RollPercentage( self.rupture_chance ) then
			if params.target ~= nil then
				params.target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_bloodseeker_rupture", { duration = self.rupture_duration } )
				EmitSoundOn( "DOTA_Item.Maim", params.target )
			end
		end
	end
	return 0
end

--------------------------------------------------------------------------------