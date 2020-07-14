modifier_item_the_caustic_finale = class({})

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.caustic_duration = self:GetAbility():GetSpecialValueFor( "caustic_duration" )
	self.max_stack_count = self:GetAbility():GetSpecialValueFor( "max_stack_count" )
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			local Target = params.target
			if Target ~= nil then
				local hCausticBuff = Target:FindModifierByName( "modifier_sand_king_boss_caustic_finale" )
				if hCausticBuff == nil then
					hCausticBuff = Target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_sand_king_boss_caustic_finale", { duration = self.caustic_duration } )
					if hCausticBuff ~= nil then
						hCausticBuff:SetStackCount( 0 )
					end
				end
				if hCausticBuff ~= nil then
					hCausticBuff:SetStackCount( math.min( hCausticBuff:GetStackCount() + 1, self.max_stack_count ) )
					hCausticBuff:SetDuration( self.caustic_duration, true )
				end
			end
		end
	end
	return 0 
end

-----------------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_item_the_caustic_finale:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

