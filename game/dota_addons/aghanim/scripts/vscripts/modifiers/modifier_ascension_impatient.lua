
modifier_ascension_impatient = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_impatient:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_impatient:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_impatient:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.max_stacks = self:GetAbility():GetSpecialValueFor( "max_stacks" )
	self.duration_per_stack = self:GetAbility():GetSpecialValueFor( "duration_per_stack" )
	self.model_scale_per_stack = self:GetAbility():GetSpecialValueFor( "model_scale_per_stack" )
	self.bonus_outgoing_damage_pct_per_stack = self:GetAbility():GetSpecialValueFor( "bonus_outgoing_damage_pct_per_stack" )
	self.bonus_health_pct_per_stack= self:GetAbility():GetSpecialValueFor( "bonus_health_pct_per_stack" )

	if IsServer() then
		self:SetStackCount( 0 )
		self.duration_per_stack = self:GetAbility():GetSpecialValueFor( "duration_per_stack" )
		self:StartIntervalThink( self.duration_per_stack )
	end
end

--------------------------------------------------------------------------------

function modifier_ascension_impatient:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()
		self:GetParent():CalculateGenericBonuses()
	end
end

--------------------------------------------------------------------------------

function modifier_ascension_impatient:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_impatient:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_impatient:GetModifierModelScale( params )
	return self.model_scale_per_stack * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_ascension_impatient:GetModifierTotalDamageOutgoing_Percentage( params )
	return self.bonus_outgoing_damage_pct_per_stack * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_ascension_impatient:GetModifierExtraHealthPercentage( params )
	return self.bonus_health_pct_per_stack * self:GetStackCount()
end

