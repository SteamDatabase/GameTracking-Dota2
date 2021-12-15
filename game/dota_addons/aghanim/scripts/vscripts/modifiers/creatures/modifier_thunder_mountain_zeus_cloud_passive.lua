
modifier_thunder_mountain_zeus_cloud_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
	}
	
	return state
end

--------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:OnCreated( kv )
	self.status_resist = self:GetAbility():GetSpecialValueFor( "status_resist" )
end

--------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:OnRefresh( kv )
	self.status_resist = self:GetAbility():GetSpecialValueFor( "status_resist" )
end

-----------------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_thunder_mountain_zeus_cloud_passive:GetModifierStatusResistanceStacking( params )
	return self.status_resist 
end

