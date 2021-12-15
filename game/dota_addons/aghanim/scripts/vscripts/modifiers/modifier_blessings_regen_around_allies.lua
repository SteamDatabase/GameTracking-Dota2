modifier_blessings_regen_around_allies = class({})

--------------------------------------------------------------------------------

function modifier_blessings_regen_around_allies:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessings_regen_around_allies:OnCreated( kv )
			self:SetStackCount(100)
	self.bRegen = true
	if IsServer() then

		self.radius = self:GetAbility():GetLevelSpecialValueFor( "radius", 1 )
		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_blessings_regen_around_allies:AddCustomTransmitterData( )
	return
	{
		isRegen = ( self.bRegen and 1 ) or 0,
	}
end

--------------------------------------------------------------------------------

function modifier_blessings_regen_around_allies:HandleCustomTransmitterData( data )
	--if data.isRegen ~= nil then
		self.bRegen = tonumber( data.isRegen ) == 1
	--end
end
--------------------------------------------------------------------------------

function modifier_blessings_regen_around_allies:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessings_regen_around_allies:GetModifierConstantHealthRegen( params )
	if IsServer() then

		local bOldRegen = self.bRegen

		local hAllies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false )
		if #hAllies > 1 then
			self.bRegen = true
		else
			self.bRegen = false
		end
		if bOldRegen ~= self.bRegen then
			self:SendBuffRefreshToClients()
		end
	end

	if self.bRegen == false then 
		return 0 
	end
	return self:GetStackCount()
end
