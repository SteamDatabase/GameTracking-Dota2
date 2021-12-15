modifier_blessings_melee_cleave = class({})

--------------------------------------------------------------------------------

function modifier_blessings_melee_cleave:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessings_melee_cleave:OnCreated( kv )
	if IsServer() then
		self.cleave_starting_width = self:GetAbility():GetLevelSpecialValueFor( "cleave_starting_width", 1 )
		self.cleave_ending_width = self:GetAbility():GetLevelSpecialValueFor( "cleave_ending_width", 1 )
		self.cleave_distance = self:GetAbility():GetLevelSpecialValueFor( "cleave_distance", 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_blessings_melee_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessings_melee_cleave:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent():IsRangedAttacker() == false then

				local cleaveDamage = ( self:GetStackCount() * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, "particles/items_fx/battlefury_cleave.vpcf" )
			end
		end
	end
	
	return 0
end

--------------------------------------------------------------------------------
function modifier_blessings_melee_cleave:IsPermanent()
	return true
end
