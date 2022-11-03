if modifier_soldier_regen == nil then
modifier_soldier_regen = class({})
end

------------------------------------------------------------------------------

function modifier_soldier_regen:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_soldier_regen:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_soldier_regen:OnCreated( kv )
	if IsServer() == true then
		self:StartIntervalThink( 0.5 )
		self.flLastHitTime = -1000
		self.bBuildingInRange = false
	end
end

-----------------------------------------------------------------------------------------

function modifier_soldier_regen:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_soldier_regen:OnTakeDamage( params )
	if IsServer() then
		if self:GetParent() == params.unit then
			if params.unit ~= nil and params.unit:IsAlive() and params.unit:IsNull() == false then
				self.flLastHitTime = GameRules:GetDOTATime( false, true )
			end
		end
	end

	return 0.0

end

--------------------------------------------------------------------------------

function modifier_soldier_regen:GetModifierHealthRegenPercentage( params )
	if IsServer() then
		if self.bBuildingInRange == false or self.flLastHitTime + self:GetAbility():GetLevelSpecialValueFor( "peace_time", 5 ) < GameRules:GetDOTATime( false, true ) then
			return 0
		end
		return self:GetAbility():GetLevelSpecialValueFor( "regen_pct", 5 )
	end

	return 0
end 

-----------------------------------------------------------------------------------------

function modifier_soldier_regen:OnIntervalThink()
	if IsServer() == false then
		return
	end

	local nRadius = self:GetAbility():GetLevelSpecialValueFor( "radius", 500 )
	local hBuildings = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), , nRadius, DOTA_UNIT_TARGET_BUILDING, 0, FIND_ANY_ORDER, false )
	self.bBuildingInRange = #hBuildings > 0
end
