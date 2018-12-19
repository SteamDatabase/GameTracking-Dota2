--[[
	CHoldoutGameSpawner - A single unit spawner for Holdout.
]]
if CHoldoutGameSpawner == nil then
	CHoldoutGameSpawner = class({})
end


function CHoldoutGameSpawner:ReadConfiguration( name, kv, gameRound )
	self._gameRound = gameRound
	self._dependentSpawners = {}

	self._szChampionNPCClassName = kv.ChampionNPCName or ""
	self._szGroupWithUnit = kv.GroupWithUnit or ""
	self._szName = name
	self._szNPCClassName = kv.NPCName or ""
	self._szSpawnerName = kv.SpawnerName or ""
	self._szSneakySpawnerName = kv.SneakySpawnerName or ""
	self._szWaitForUnit = kv.WaitForUnit or ""
	self._szWaypointName = kv.Waypoint or ""
	self._szSneakyWaypointName = kv.SneakyWaypoint or ""
	self._waypointEntity = nil

	self._nChampionLevel = tonumber( kv.ChampionLevel or 1 )
	self._nChampionMax = tonumber( kv.ChampionMax or 1 )
	self._nChampionIntervalMax = tonumber( kv.ChampionIntervalMax or 999 )
	self._flChampionModelScale = tonumber( kv.ChampionModelScale or 1.5 )
	self._nCreatureLevel = tonumber( kv.CreatureLevel or 1 )
	self._nTotalUnitsToSpawn = tonumber( kv.TotalUnitsToSpawn or 0 )
	self._nUnitsPerSpawn = tonumber( kv.UnitsPerSpawn or 0 )
	self._nUnitsPerSpawn = tonumber( kv.UnitsPerSpawn or 1 )

	self._flChampionChance = tonumber( kv.ChampionChance or 0 )
	self._flInitialWait = tonumber( kv.WaitForTime or 0 )
	self._flSpawnInterval = tonumber( kv.SpawnInterval or 0 )

	self._bDontGiveGoal = ( tonumber( kv.DontGiveGoal or 0 ) ~= 0 )
	self._bDontOffsetSpawn = ( tonumber( kv.DontOffsetSpawn or 0 ) ~= 0 )

	self._bIsFriendly = ( tonumber( kv.IsFriendly or 0 ) ~= 0 )
end


function CHoldoutGameSpawner:PostLoad( spawnerList )
	self._waitForUnit = spawnerList[ self._szWaitForUnit ]
	if self._szWaitForUnit ~= "" and not self._waitForUnit then
		print( self._szName .. " has a wait for unit " .. self._szWaitForUnit .. " that is missing from the round data." )
	elseif self._waitForUnit then
		table.insert( self._waitForUnit._dependentSpawners, self )
	end

	self._groupWithUnit = spawnerList[ self._szGroupWithUnit ]
	if self._szGroupWithUnit ~= "" and not self._groupWithUnit then
		print ( self._szName .. " has a group with unit " .. self._szGroupWithUnit .. " that is missing from the round data." )
	elseif self._groupWithUnit then
		table.insert( self._groupWithUnit._dependentSpawners, self )
	end
end


function CHoldoutGameSpawner:Precache()
	PrecacheUnitByNameAsync( self._szNPCClassName, function( sg ) self._sg = sg end )
	if self._szChampionNPCClassName ~= "" then
		PrecacheUnitByNameAsync( self._szChampionNPCClassName, function( sg ) self._sgChampion = sg end )
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:Begin()
	self._nUnitsSpawnedThisRound = 0
	self._nChampionsSpawnedThisRound = 0
	self._nUnitsCurrentlyAlive = 0

	local bIsSneaky = false
	if string.find( self._szName, "sneaky" ) then
		bIsSneaky = true
	end

	if bIsSneaky == false then
		self:_SetSpawnLoc()
		self:_SetWaypoint()
	else
		print( string.format( "bIsSneaky is true for %s", self._szName ) )
		self:_SetSneakySpawnLoc()
		self:_SetSneakyWaypoint()
	end

	if self._waitForUnit ~= nil or self._groupWithUnit ~= nil then
		self._flNextSpawnTime = nil
	else
		self._flNextSpawnTime = GameRules:GetGameTime() + self._flInitialWait
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_SetSpawnLoc()
	self._vecSpawnLocation = nil
	if self._szSpawnerName ~= "" then
		local entSpawner = Entities:FindByName( nil, self._szSpawnerName )
		if not entSpawner then
			print( string.format( "Failed to find spawner named %s for %s\n", self._szSpawnerName, self._szName ) )
		end
		self._vecSpawnLocation = entSpawner:GetAbsOrigin()
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_SetWaypoint()
	self._entWaypoint = nil
	if self._szWaypointName ~= "" and not self._bDontGiveGoal then
		self._entWaypoint = Entities:FindByName( nil, self._szWaypointName )
		if not self._entWaypoint then
			print( string.format( "Failed to find waypoint named %s for %s", self._szWaypointName, self._szName ) )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_SetSneakySpawnLoc()
	self._vecSneakySpawnLocation = nil
	if self._szSneakySpawnerName ~= "" then
		local entSpawner = Entities:FindByName( nil, self._szSneakySpawnerName )
		if not entSpawner then
			print( string.format( "Failed to find sneaky spawner named %s for %s\n", self._szSneakySpawnerName, self._szName ) )
		end
		print( "_SetSneakySpawnLoc - setting self._vecSneakySpawnLocation" )
		self._vecSneakySpawnLocation = entSpawner:GetAbsOrigin()
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_SetSneakyWaypoint()
	self._entSneakyWaypoint = nil
	if self._szSneakyWaypointName ~= "" and not self._bDontGiveGoal then
		print( "_SetSneakyWaypoint - setting self._entSneakyWaypoint" )
		self._entSneakyWaypoint = Entities:FindByName( nil, self._szSneakyWaypointName )
		if not self._entSneakyWaypoint then
			print( string.format( "Failed to find sneaky waypoint named %s for %s", self._szSneakyWaypointName, self._szName ) )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:End()
	if self._sg ~= nil then
		UnloadSpawnGroupByHandle( self._sg )
		self._sg = nil
	end
	if self._sgChampion ~= nil then
		UnloadSpawnGroupByHandle( self._sgChampion )
		self._sgChampion = nil
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:ParentSpawned( parentSpawner )
	if parentSpawner == self._groupWithUnit then
		-- Make sure we use the same spawn location as parentSpawner.
		self:_DoSpawn()
	elseif parentSpawner == self._waitForUnit then
		if parentSpawner:IsFinishedSpawning() and self._flNextSpawnTime == nil then
			self._flNextSpawnTime = parentSpawner._flNextSpawnTime + self._flInitialWait
		end
	end
end


function CHoldoutGameSpawner:CheckEnemiesRemaining()
	local nEnemiesRemaining = self._gameRound:GetRemainingUnits()

	if self:IsFinishedSpawning() and nEnemiesRemaining <= 5 then
		self._gameRound:ApplyVisionToRemainingEnemies()
	end
end

function CHoldoutGameSpawner:Think()
	if self:IsFinishedSpawning() == true then
		self:CheckEnemiesRemaining()
	end

	if not self._flNextSpawnTime then
		return
	end
	
	if GameRules:GetGameTime() >= self._flNextSpawnTime then
		self:_DoSpawn()
		for _,s in pairs( self._dependentSpawners ) do
			s:ParentSpawned( self )
		end

		if self:IsFinishedSpawning() then
			self._flNextSpawnTime = nil
		else
			self._flNextSpawnTime = self._flNextSpawnTime + self._flSpawnInterval
		end
	end
end


function CHoldoutGameSpawner:GetTotalUnitsToSpawn()
	return self._nTotalUnitsToSpawn
end


function CHoldoutGameSpawner:IsFinishedSpawning()
	return ( self._nTotalUnitsToSpawn <= self._nUnitsSpawnedThisRound ) or ( self._groupWithUnit ~= nil )
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_GetSpawnLocation()
	if self._groupWithUnit then
		return self._groupWithUnit:_GetSpawnLocation()
	else
		return self._vecSpawnLocation
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_GetSneakySpawnLocation()
	if self._groupWithUnit then
		return self._groupWithUnit:_GetSneakySpawnLocation()
	else
		return self._vecSneakySpawnLocation
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_GetSpawnWaypoint()
	if self._groupWithUnit then
		return self._groupWithUnit:_GetSpawnWaypoint()
	else
		return self._entWaypoint
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_GetSneakySpawnWaypoint()
	if self._groupWithUnit then
		return self._groupWithUnit:_GetSneakySpawnWaypoint()
	else
		return self._entSneakyWaypoint
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_UpdateRandomSpawn()
	self._vecSpawnLocation = Vector( 0, 0, 0 )
	self._entWaypoint = nil

	local spawnInfo = self._gameRound:ChooseRandomSpawnInfo()
	if spawnInfo == nil then
		print( string.format( "Failed to get random spawn info for spawner %s.", self._szName ) )
		return
	end
	
	local entSpawner = Entities:FindByName( nil, spawnInfo.szSpawnerName )
	if not entSpawner then
		print( string.format( "Failed to find spawner named %s for %s.", spawnInfo.szSpawnerName, self._szName ) )
		return
	end
	self._vecSpawnLocation = entSpawner:GetAbsOrigin()

	if not self._bDontGiveGoal then
		self._entWaypoint = Entities:FindByName( nil, spawnInfo.szFirstWaypoint )
		if not self._entWaypoint then
			print( string.format( "Failed to find a waypoint named %s for %s.", spawnInfo.szFirstWaypoint, self._szName ) )
			return
		end
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_UpdateRandomSneakySpawn()
	self._vecSneakySpawnLocation = Vector( 0, 0, 0 )
	self._entSneakyWaypoint = nil

	local spawnInfo = self._gameRound:ChooseRandomSneakySpawnInfo()
	if spawnInfo == nil then
		print( string.format( "Failed to get random spawn info for spawner %s.", self._szName ) )
		return
	end
	
	local entSpawner = Entities:FindByName( nil, spawnInfo.szSpawnerName )
	if not entSpawner then
		print( string.format( "Failed to find spawner named %s for %s.", spawnInfo.szSpawnerName, self._szName ) )
		return
	end
	self._vecSneakySpawnLocation = entSpawner:GetAbsOrigin()

	if not self._bDontGiveGoal then
		self._entSneakyWaypoint = Entities:FindByName( nil, spawnInfo.szFirstWaypoint )
		if not self._entSneakyWaypoint then
			print( string.format( "Failed to find a waypoint named %s for %s.", spawnInfo.szFirstWaypoint, self._szName ) )
			return
		end
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:_DoSpawn()
	local nUnitsToSpawn = math.min( self._nUnitsPerSpawn, self._nTotalUnitsToSpawn - self._nUnitsSpawnedThisRound )

	local nChampionsSpawnedThisInterval = 0

	local bIsSneakyUnit = ( self._szNPCClassName == "npc_dota_creature_sneaky_pillager" )

	if nUnitsToSpawn <= 0 then
		return
	elseif self._nUnitsSpawnedThisRound == 0 then
		print( string.format( "Started spawning %s at %.2f", self._szName, GameRules:GetGameTime() ) )
	end

	if bIsSneakyUnit == false then
		if self._szSpawnerName == "" then
			self:_UpdateRandomSpawn()
		end
	else
		if self._szSpawnerName == "" then
			self:_UpdateRandomSneakySpawn()
		end
	end

	local vBaseSpawnLocation = nil
	if bIsSneakyUnit == false then
		vBaseSpawnLocation = self:_GetSpawnLocation()
	else
		vBaseSpawnLocation = self:_GetSneakySpawnLocation()
	end

	if not vBaseSpawnLocation then return end
	for iUnit = 1, nUnitsToSpawn do
		local bIsChampion = RollPercentage( self._flChampionChance )
		if self._nChampionsSpawnedThisRound >= self._nChampionMax or nChampionsSpawnedThisInterval >= self._nChampionIntervalMax then
			bIsChampion = false
		end

		local szNPCClassToSpawn = self._szNPCClassName
		if bIsChampion and self._szChampionNPCClassName ~= "" then
			szNPCClassToSpawn = self._szChampionNPCClassName
		end

		local vSpawnLocation = vBaseSpawnLocation

		if not self._bDontOffsetSpawn then
			vSpawnLocation = vSpawnLocation + RandomVector( RandomFloat( 0, 200 ) )
		end

		local entUnit = CreateUnitByName( szNPCClassToSpawn, vSpawnLocation, true, nil, nil, DOTA_TEAM_BADGUYS )
		if entUnit then
			if entUnit:IsCreature() then
				if bIsChampion then
					self._nChampionsSpawnedThisRound = self._nChampionsSpawnedThisRound + 1
					nChampionsSpawnedThisInterval = nChampionsSpawnedThisInterval + 1
					entUnit:CreatureLevelUp( ( self._nChampionLevel - 1 ) )
					entUnit:SetChampion( true )
					if self._szChampionNPCClassName == "" then
						entUnit:SetModelScale( self._flChampionModelScale )
					end
				else
					entUnit:CreatureLevelUp( self._nCreatureLevel - 1 )
				end
			end

			if bIsSneakyUnit == false then
				local entWp = self:_GetSpawnWaypoint()
				if entWp ~= nil then
					entUnit:SetInitialGoalEntity( entWp )
				end
			else
				local entWp = self:_GetSneakySpawnWaypoint()
				if entWp ~= nil then
					entUnit:SetInitialGoalEntity( entWp )
				end
			end

			if self._bIsFriendly then
				entUnit:SetTeam( DOTA_TEAM_GOODGUYS )
			end

			if entUnit:GetUnitName() == "npc_dota_sled_penguin" then
				self:MovePenguinToStartPos( entUnit )
			end

			self._nUnitsSpawnedThisRound = self._nUnitsSpawnedThisRound + 1
			self._nUnitsCurrentlyAlive = self._nUnitsCurrentlyAlive + 1
			entUnit.Holdout_IsCore = true
			entUnit:SetDeathXP( 0 )
			entUnit:SetMaximumGoldBounty( 0 )
			entUnit:SetMinimumGoldBounty( 0 )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:StatusReport()
	print( string.format( "** Spawner %s", self._szNPCClassName ) )
	print( string.format( "%d of %d spawned", self._nUnitsSpawnedThisRound, self._nTotalUnitsToSpawn ) )
end

--------------------------------------------------------------------------------

function CHoldoutGameSpawner:MovePenguinToStartPos( hPenguin )
	local hAllHeroes = HeroList:GetAllHeroes()
	for i = 1, #hAllHeroes do
		local hHero = hAllHeroes[ i ]
		if hHero and hHero:IsAlive() and hHero:IsRealHero() and hHero:IsTempestDouble() == false and hHero.hPenguin == nil then
			local hPassiveBuff = hPenguin:FindModifierByName( "modifier_sled_penguin_passive" )
			if hPassiveBuff ~= nil then
				hPassiveBuff.hPlayerEnt = hHero
				local hPenguinPassiveAbility = hPenguin:FindAbilityByName( "sled_penguin_passive" )
				if hPenguinPassiveAbility then
					print( string.format( "MovePenguinToStartPos - Found hero named %s that doesn't have an hPenguin, adding hPenguin to it", hHero:GetUnitName() ) )
					hHero.hPenguin = hPenguin
					FindClearSpaceForUnit( hPenguin, hHero:GetAbsOrigin(), true )
					hPenguin:SetForwardVector( hHero:GetForwardVector() )
					hHero:AddNewModifier( hPenguin, hPenguinPassiveAbility, "modifier_sled_penguin_movement", {} )
					hPenguin:AddNewModifier( hPenguin, hPenguinPassiveAbility, "modifier_sled_penguin_movement", {} )
					return
				end
			end
		end
	end

	print( "WARNING: found no appropriate parent hero for this penguin, placing it at ( 0, 0, 0 )" )
	FindClearSpaceForUnit( hPenguin, Vector( 0, 0, 0 ), true )
end

--------------------------------------------------------------------------------