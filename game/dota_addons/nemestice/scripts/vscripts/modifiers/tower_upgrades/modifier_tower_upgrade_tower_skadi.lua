
if modifier_tower_upgrade_tower_skadi == nil then
	modifier_tower_upgrade_tower_skadi = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:IsHidden()
	return true
end

------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:OnCreated( kv )
	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
		self.cold_duration = self:GetAbility():GetSpecialValueFor( "cold_duration" )
	end
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:OnRefresh( kv )
	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
		self.cold_duration = self:GetAbility():GetSpecialValueFor( "cold_duration" )
	end
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:GetModifierProjectileName( params )
	return "particles/items2_fx/skadi_projectile.vpcf"
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_skadi:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and params.target ~= nil then
			local kv = { duration = self.cold_duration }
			params.target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_item_skadi_slow", kv )
		end
	end

	return 0
end