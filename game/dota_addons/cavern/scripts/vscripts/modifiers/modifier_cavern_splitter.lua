
modifier_cavern_splitter = class({})

--------------------------------------------------------------------------------

function modifier_cavern_splitter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_cavern_splitter:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_cavern_splitter:OnCreated( kv )
	if IsServer() then
		self.split_child = self:GetAbility():GetSpecialValueFor( "split_child" )
		self.split_count = self:GetAbility():GetSpecialValueFor( "split_count" )
	end
end

--------------------------------------------------------------------------------

function modifier_cavern_splitter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_cavern_splitter:OnDeath( params )
	if IsServer() then
		if ( params.unit == self:GetParent() ) then
			for i = 1,self.split_count do
				local szChildName = self:GetParent():GetUnitName()
				szChildName = string.sub(szChildName,1,-2) .. tostring(self.split_child)
				self:GetParent().hEncounter:SpawnCreepByName(szChildName, self:GetParent():GetOrigin() + RandomVector(100), true, nil, nil, self:GetParent():GetTeamNumber() )
			end
		end
	end
end

--------------------------------------------------------------------------------
