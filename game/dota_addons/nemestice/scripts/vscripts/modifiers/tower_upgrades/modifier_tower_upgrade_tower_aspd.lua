
if modifier_tower_upgrade_tower_aspd == nil then
	modifier_tower_upgrade_tower_aspd = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:GetEffectName() 
	return "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:ShouldUseOverheadOffset()  
	return true 
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:GetStatusEffectName()  
	return "particles/status_fx/status_effect_alacrity.vpcf"; 
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:StatusEffectPriority() 
	return 15
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:OnCreated( kv )
	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
		self.aspd = self:GetAbility():GetSpecialValueFor( "bonus_aspd" )
	end
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:OnRefresh( kv )
	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
		self.aspd = self:GetAbility():GetSpecialValueFor( "bonus_aspd" )
	end
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_aspd:GetModifierAttackSpeedBonus_Constant( params )
	if self.aspd == nil then
		return 0
	end

	return self.aspd
end