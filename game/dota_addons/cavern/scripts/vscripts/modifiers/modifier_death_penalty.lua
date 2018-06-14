
modifier_death_penalty = class({})


--------------------------------------------------------------------------------

function modifier_death_penalty:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_death_penalty:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_death_penalty:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_death_penalty:IsPermanent()
	return true
end

---------------------------------------------------------

function modifier_death_penalty:RemoveOnDeath()
	return false
end 

---------------------------------------------------------

function modifier_death_penalty:OnCreated( kv )
	self.HeroRespawnTable = { 5, 7, 9, 13, 16, 26, 28, 30, 32, 34, 36, 44, 46, 48, 50, 52, 54, 65, 70, 75, 80, 85, 90, 95, 100, }
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_death_penalty:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_RESPAWNTIME,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_death_penalty:GetModifierConstantRespawnTime( params )
	--print("constant respawn time " .. self:GetParent().nDeaths)
	local nDeaths = self:GetParent().nDeaths
	if nDeaths == nil then
		nDeaths = 0
	end
	nDeaths = math.min(nDeaths,3)

	-- pretty hacky, but we can subtract the base hero respawn time to set it to exactly what we want
	return 15 * math.pow(2,nDeaths) - self.HeroRespawnTable[self:GetParent():GetLevel()]

end

-----------------------------------------------------------------------

