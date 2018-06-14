modifier_generic_spawner = class({})

--------------------------------------------------------------------------------

function modifier_generic_spawner:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_spawner:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_spawner:OnCreated( kv )

	if IsServer() then
	
		self.npc_name = kv[ "npc_name" ]
		self.spawn_rate = kv[ "spawn_rate" ]	
		self.max_spawns = kv[ "max_spawns" ]
		self.radius = kv["radius"]
		self.spawns_give_xp_gold = kv["spawns_give_xp_gold"]
		self.timeout_after_disable = kv["timeout_after_disable"]
		self.on_take_damage = kv[ "on_take_damage" ]

		if self.npc_name == nil then
			printf("Error: modifier_generic_spawner, no value defined for kv[\"npc_name\")")
			return
		end

		if self.spawn_rate == nil then
			self.spawn_rate = 1
		end

		if self.radius == nil then
			self.radius = 100
		end

		if self.timeout_after_disable == nil then
			self.timeout_after_disable = -1
		end

		if self.on_take_damage == nil then
			self.on_take_damage = false
		end

		self.flLastDisabledTime = -1e10

		self.bDisabled = false

		self.SpawnedUnits = {}

		self.nHP = self:GetParent():GetHealth()

		self:StartIntervalThink( self.spawn_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_generic_spawner:OnIntervalThink()
	if IsServer() then
		
		if self.bDisabled then
			return
		end


		local hParent = self:GetParent()
		local hEncounter = hParent.hEncounter
		local nOldHP = self.nHP
		self.nHP = hParent:GetHealth()
		
		--printf("max spawns %d current spawns %d", self.max_spawns, #self.SpawnedUnits)
		--printf("on take damage %d new health %f old health %f", self.on_take_damage, self.nHP, nOldHP)

		if self.on_take_damage and self.nHP >= nOldHP then
			return
		end

		if self.max_spawns ~= nil then
			local nSpawnedUnits = 0
			for key,hUnit in pairs(self.SpawnedUnits) do
				if not hUnit:IsNull() and hUnit:IsAlive() then 
					nSpawnedUnits = nSpawnedUnits + 1
				end
			end
			if (nSpawnedUnits >= self.max_spawns) then
				return
			end
		end	
		
		
		self.nLastHP = hParent:GetHealth()

		vSpawnPoint = hParent:GetAbsOrigin() + RandomVector(self.radius)
		local hUnit = nil
		if self.spawns_give_xp_gold then
			hUnit = hEncounter:SpawnCreepByName(self.npc_name, vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
			hUnit.flSpawnTime = GameRules:GetGameTime()
		else
			hUnit = hEncounter:SpawnNonCreepByName(self.npc_name, vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
			hUnit.flSpawnTime = GameRules:GetGameTime()
		end

		hUnit:SetForwardVector( hUnit:GetAbsOrigin() - hParent:GetAbsOrigin() )

		table.insert( self.SpawnedUnits, hUnit )

		--[[
		if self.timeout_after_disable > 0 then
			for _,hUnit in pairs(self.SpawnedUnits) do
				if (self.flLastDisabledTime - hUnit.flSpawnTime) > self.timeout_after_disable then
					UTIL_Remove(hUnit)
				end
			end
		end
		]]

	end
end


function modifier_generic_spawner:SetDisabled(bDisabled)

	if self.bDisabled == false and bDisabled == true then
		self.flLastDisabledTime = GameRules:GetGameTime()
	end

	self.bDisabled = bDisabled

end

--------------------------------------------------------------------------------
