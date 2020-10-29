--[[
	CDiretideGameSpawner - A single wave spawner for Diretide. Can include a number of units.
]]
if CDiretideGameSpawner == nil then
	CDiretideGameSpawner = class({})
end

-- the team of units spawned by this spawner is controlled by
-- constants.DIRETIDE_FLIP_SPAWNER_TEAM_NUMBERS since we originally
-- created a spawner of team Radiant on the Radiant side of the map
-- that spawned Dire creeps ( DIRETIDE_FLIP_SPAWNER_TEAM_NUMBERS == true)
-- but we can toggle that.
function CDiretideGameSpawner:ReadConfiguration( name, kv, hWaveManager, nTeam )
	--print( "CDiretideGameSpawner:ReadConfiguration for " .. name )
	--DeepPrintTable( kv )

	self.hWaveManager = hWaveManager
	self.nTeam = nTeam

	self._szName = name

	self._nGroupsToSpawn = tonumber ( kv.GroupsToSpawn or 1 )
	self._flInitialWait = tonumber( kv.WaitForTime or 0 )
	self._flSpawnInterval = tonumber( kv.SpawnInterval or 0 )
	self._bInfiniteGroups = kv.RepeatInfinitely or false
	self._nModifierBuffLevel = 0
	self._bDontGiveGoal = ( tonumber( kv.DontGiveGoal or 0 ) ~= 0 )

	self._vUnits = {}
	for _, v in ipairs( kv.Units) do
		local unit =
		{
			szNPCClassName = v.NPCName or "",
			szNPCClassNameRadiant = v.NPCNameRadiant or "",
			szNPCClassNameDire = v.NPCNameDire or "",
			nCreatureLevel = tonumber( v.CreatureLevel or 1 ),
			nUnitCount = tonumber( v.UnitCount or 1 ),
			nCandyCount = tonumber( v.CandyCount or 0 ),
		}
		if ( unit.szNPCClassName and unit.szNPCClassName ~= "" ) or ( unit.szNPCClassNameRadiant and unit.szNPCClassNameRadiant ~= "" and unit.szNPCClassNameDire and unit.szNPCClassNameDire ~= "" ) then
			table.insert( self._vUnits, unit )
		end
	end

	
	self._nUnitsPerGroup = 0
	for _, v in ipairs( self._vUnits ) do
		self._nUnitsPerGroup = self._nUnitsPerGroup + v.nUnitCount
	end
	self._nTotalUnitsToSpawn = self._nUnitsPerGroup * self._nGroupsToSpawn
	if _G.DIRETIDE_CREEPS_SPAWN_FROM_ALL_SPAWNPOINTS == true then
		local tSpawnPoints = GameRules.Diretide:GetSpawnInfos()
		self._nTotalUnitsToSpawn = self._nTotalUnitsToSpawn * #tSpawnPoints
	end
end


function CDiretideGameSpawner:Precache()
	self._vsg = {}
	for _, v in ipairs( self._vUnits ) do
		if v.szNPCClassName and v.szNPCClassName ~= "" then
			PrecacheUnitByNameAsync( v.szNPCClassName, function( sg ) if self._vsg ~= nil then table.insert( self._vsg, sg ) end end )
		else
			PrecacheUnitByNameAsync( v.szNPCClassNameRadiant, function( sg ) if self._vsg ~= nil then table.insert( self._vsg, sg ) end end )
			PrecacheUnitByNameAsync( v.szNPCClassNameDire, function( sg ) if self._vsg ~= nil then table.insert( self._vsg, sg ) end end )
		end
	end
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:Begin()
	self._nUnitsSpawnedThisRound = 0
	self._nGroupsRemaining = self._nGroupsToSpawn

	self._flNextSpawnTime = GameRules:GetDOTATime( false, true ) + self._flInitialWait
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:End()
	if self._vsg ~= nil then
		for _, v in pairs( self._vsg ) do
			UnloadSpawnGroupByHandle( v )
		end
		self._vsg = nil
	end
end

function CDiretideGameSpawner:Think()
	if not self._flNextSpawnTime then
		return
	end
	
	if GameRules:GetDOTATime( false, true ) >= self._flNextSpawnTime then
		self:_DoSpawn( false, nil )
		
		if self:IsFinishedSpawning() then
			self._flNextSpawnTime = nil
		else
			self._flNextSpawnTime = self._flNextSpawnTime + self._flSpawnInterval
		end
	end
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:GetTotalUnitsToSpawn()
	return self._nTotalUnitsToSpawn
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:GetTotalCandy()
	print( '	Total Candy for spawner named ' .. self._szName .. ':' )
	local nCandyPerGroup = 0
	for _, v in ipairs( self._vUnits ) do
		nCandyPerGroup = nCandyPerGroup + v.nCandyCount
	end
	print( '	Candy per group = ' .. nCandyPerGroup )

	nTotalCandy = nCandyPerGroup * self._nGroupsToSpawn
	print( '	Total candy across all groups = ' .. nTotalCandy )
	
	if _G.DIRETIDE_CREEPS_SPAWN_FROM_ALL_SPAWNPOINTS == true then
		local tSpawnPoints = GameRules.Diretide:GetSpawnInfos()
		nTotalCandy = nTotalCandy * #tSpawnPoints
	end

	print( 'Game Spawner total candy (across all spawn points) = ' .. nTotalCandy )

	return nTotalCandy
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:IsFinishedSpawning()
	return self._nGroupsRemaining <= 0 and self._bInfiniteGroups == false
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:_UpdateRandomSpawn( tSpawnData )
	local spawnData = {}
	spawnData.vSpawnLocation = nil
	spawnData.entWaypoint = nil

	local spawnInfo = GameRules.Diretide:ChooseRandomSpawnInfo()
	if spawnInfo == nil then
		print( string.format( "Failed to get random spawn info for spawner %s.", self._szName ) )
		return
	end

	local spawnerName = nil
	local nTeam = self.nTeam
	if nTeam == DOTA_TEAM_GOODGUYS then
		spawnerName = string.format( "radiant_" .. spawnInfo.szSpawnerName )
	elseif nTeam == DOTA_TEAM_BADGUYS then
		spawnerName = string.format( "dire_" .. spawnInfo.szSpawnerName )
	else
		error( "INVALID TEAM FOR CDiretideGameSpawner:_UpdateRandomSpawn() " .. self.nTeam )
	end

	local entSpawner = Entities:FindByName( nil, spawnerName )
	if not entSpawner then
		print( string.format( "Failed to find spawner named %s for %s\n", spawnerName, self._szName ) )
		spawnData.vSpawnLocation = Vector( 0, 0, 0 )
	else
		spawnData.vSpawnLocation = entSpawner:GetAbsOrigin()
	end

	if not self._bDontGiveGoal then
		local waypointName = nil
		if nTeam == DOTA_TEAM_GOODGUYS then
			waypointName = string.format( "radiant_" .. spawnInfo.szFirstWaypoint )
		elseif nTeam == DOTA_TEAM_BADGUYS then
			waypointName = string.format( "dire_" .. spawnInfo.szFirstWaypoint )
		else
			error( "INVALID TEAM FOR CDiretideGameSpawner:_UpdateRandomSpawn() " .. nTeam )
		end

		spawnData.entWaypoint = Entities:FindByName( nil, waypointName )
		if not spawnData.entWaypoint then
			print( string.format( "Failed to find a waypoint named %s for %s.", waypointName, self._szName ) )
			return
		end
	end

	table.insert( tSpawnData, spawnData )
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:_FillSpawnData( tSpawnData )
	local tSpawnInfos = GameRules.Diretide:GetSpawnInfos()
	if tSpawnInfos == nil then
		print( string.format( "Failed to get spawn infos for spawner %s.", self._szName ) )
		return
	end

	for _, spawnInfo in pairs( tSpawnInfos ) do
		local spawnData = {}
		spawnData.vSpawnLocation = nil
		spawnData.entWaypoint = nil

		local spawnerName = nil
		local nTeam = self.nTeam
		if nTeam == DOTA_TEAM_GOODGUYS then
			spawnerName = string.format( "radiant_" .. spawnInfo.szSpawnerName )
		elseif nTeam == DOTA_TEAM_BADGUYS then
			spawnerName = string.format( "dire_" .. spawnInfo.szSpawnerName )
		else
			error( "INVALID TEAM FOR CDiretideGameSpawner:_UpdateRandomSpawn() " .. self.nTeam )
		end

		local entSpawner = Entities:FindByName( nil, spawnerName )
		if not entSpawner then
			print( string.format( "Failed to find spawner named %s for %s\n", spawnerName, self._szName ) )
			spawnData.vSpawnLocation = Vector( 0, 0, 0 )
		else
			spawnData.vSpawnLocation = entSpawner:GetAbsOrigin()
		end

		if not self._bDontGiveGoal then
			local waypointName = nil
			if nTeam == DOTA_TEAM_GOODGUYS then
				waypointName = string.format( "radiant_" .. spawnInfo.szFirstWaypoint )
			elseif nTeam == DOTA_TEAM_BADGUYS then
				waypointName = string.format( "dire_" .. spawnInfo.szFirstWaypoint )
			else
				error( "INVALID TEAM FOR CDiretideGameSpawner:_UpdateRandomSpawn() " .. nTeam )
			end

			spawnData.entWaypoint = Entities:FindByName( nil, waypointName )
			if not spawnData.entWaypoint then
				print( string.format( "Failed to find a waypoint named %s for %s.", waypointName, self._szName ) )
				return
			end
		end

		table.insert( tSpawnData, spawnData )
	end
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:_DoSpawn( bIsExtraWave, tUnitOverride )
	local tSpawnData = {}
	if _G.DIRETIDE_CREEPS_SPAWN_FROM_ALL_SPAWNPOINTS == false then
		self:_UpdateRandomSpawn( tSpawnData )
	else
		self:_FillSpawnData( tSpawnData )
	end

	local vUnitDefs = self._vUnits
	if tUnitOverride ~= nil then
		vUnitDefs = {}
		table.insert(vUnitDefs, tUnitOverride)
	end

	local nSpawnTeam = self.nTeam
	if _G.DIRETIDE_FLIP_SPAWNER_TEAM_NUMBERS then
		nSpawnTeam = FlipTeamNumber( nSpawnTeam )
	end

	-- For each unit type in our group
	for _, v in pairs( vUnitDefs ) do
		-- for each spawnpoint
		for _, spawnData in pairs ( tSpawnData ) do
			if not spawnData.vSpawnLocation then return end

			-- set up the total to spawn and the candy
			local nCandyRemaining = v.nCandyCount or 0
			if bIsExtraWave == true then
				nCandyRemaining = 0
			end
			local nUnitsToSpawn = v.nUnitCount or 1
			local szNPCClassToSpawn = ""
			if v.szNPCClassName ~= nil and v.szNPCClassName ~= "" then
				szNPCClassToSpawn = v.szNPCClassName
			else
				if nSpawnTeam == DOTA_TEAM_GOODGUYS then
					szNPCClassToSpawn = v.szNPCClassNameRadiant
				else
					szNPCClassToSpawn = v.szNPCClassNameDire
				end
			end

			local nUnitsRemaining = nUnitsToSpawn
			local nCreatureLevel = v.nCreatureLevel or 1
			-- and then spawn each unit
			for iUnit = 1, nUnitsToSpawn do
				
				local entUnit = CreateUnitByName( szNPCClassToSpawn, spawnData.vSpawnLocation, true, nil, nil, nSpawnTeam )
				if entUnit then
					if entUnit:IsCreature() then

						-- this is necessary to prevent weird pathing issues with the invade behavior
						entUnit:SetRequiresReachingEndPath( true )
						entUnit:CreatureLevelUp( nCreatureLevel - 1 )
					end

					if spawnData.entWaypoint ~= nil then
						entUnit:SetInitialGoalEntity( spawnData.entWaypoint )
					end

					if bIsExtraWave == false then
						self._nUnitsSpawnedThisRound = self._nUnitsSpawnedThisRound + 1
						if self._nGroupsRemaining > 0 then
							entUnit.Diretide_bIsCore = true
						end
					end
					entUnit:SetMustReachEachGoalEntity( true )
					entUnit:SetDeathXP( 0 )
					entUnit:SetMaximumGoldBounty( 0 )
					entUnit:SetMinimumGoldBounty( 0 )

					if bIsExtraWave then
						if self._nModifierBuffLevel > 0 then
							local kv =
							{
								damage_buff_pct = self._nModifierBuffLevel * _G.DIRETIDE_INVADER_HP_PCT_BUFF_PER_SUMMON,
								hp_buff_pct = self._nModifierBuffLevel * _G.DIRETIDE_INVADER_DMG_PCT_BUFF_PER_SUMMON,
								model_scale = 1.0 + self._nModifierBuffLevel * _G.DIRETIDE_INVADER_MODEL_SCALE_INCREASE_PER_SUMMON,
							}
							entUnit:AddNewModifier( nil, nil, "modifier_creature_buff", kv )
						end
						self._nModifierBuffLevel = self._nModifierBuffLevel + 1
					end

					-- Candy logic
					if nCandyRemaining > 0 then
						local nCandyToDrop = 0
					
						-- If there's only one unit left, well, we'd better assign what candy is left
						if nUnitsRemaining == 1 then
							nCandyToDrop = nCandyRemaining
						else
							-- Otherwise if candy < units, we have a chance to drop,
							-- and if candy >= units, we drop >=1 candy.
							local flCurrentDropChance = nCandyRemaining / nUnitsRemaining
							if RandomFloat( 0, 1 ) <= flCurrentDropChance then
								nCandyToDrop = math.min( nCandyRemaining, math.max( 1, math.floor( nCandyRemaining / nUnitsRemaining ) ) )
							end
						end
	
						if nCandyToDrop > 0 then
							nCandyRemaining = nCandyRemaining - nCandyToDrop
							entUnit.Diretide_nCandy = nCandyToDrop
						end
					end

					entUnit.WaveManager = self.hWaveManager

					-- Phone home to the wave manager
					self.hWaveManager:AddSpawnedUnit( entUnit, bIsExtraWave )

					nUnitsRemaining = nUnitsRemaining - 1
				end
			end
		end
	end
	if bIsExtraWave == false then
		self._nGroupsRemaining = self._nGroupsRemaining - 1
	end
end

--------------------------------------------------------------------------------

function CDiretideGameSpawner:StatusReport()
	print( string.format( "** Spawner %s", self._szName ) )
	print( string.format( "%d of %d spawned", self._nUnitsSpawnedThisRound, self._nTotalUnitsToSpawn ) )
end
