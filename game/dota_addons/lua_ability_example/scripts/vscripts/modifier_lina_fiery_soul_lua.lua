modifier_lina_fiery_soul_lua = class({})
--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:IsHidden()
	return ( self:GetStackCount() == 0 )
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:OnCreated( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self.flFierySoulDuration = 0

	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:OnRefresh( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )

	if IsServer() then
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) ) 
	end
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:SetStackCount( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.fiery_soul_move_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.fiery_soul_attack_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_lina_fiery_soul_lua:OnAbilityExecuted( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local hAbility = params.ability 
			if hAbility ~= nil and ( not hAbility:IsItem() ) and ( not hAbility:IsToggle() ) then
				if self:GetStackCount() < self.fiery_soul_max_stacks then
					self:IncrementStackCount()
				else
					self:SetStackCount( self:GetStackCount() )
					self:ForceRefresh()
				end

				self:SetDuration( self.duration_tooltip, true )
				self:StartIntervalThink( self.duration_tooltip )
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------