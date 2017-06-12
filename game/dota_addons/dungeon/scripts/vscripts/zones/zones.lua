if GetMapName() == "ep_1" then
	require( "zones/zone_tables_ep_1" )
end

if CDungeonZone == nil then
	CDungeonZone = class({})
end

--------------------------------------------------------------------

function CDungeonZone:Init( data )
	if data == nil then
		return
	end

	self.bPrecached = false
	self.bActivated = false
	self.bZoneCompleted = false
	self.bZoneCleanupComplete = false
	self.flCompletionTime = 0.0
	self.nStars = 0
	self.nKills = 0
	self.nDeaths = 0
	self.nItems = 0
	self.nGoldBags = 0
	self.nPotions = 0
	self.nReviveTime = 0
	self.nDamage = 0
	self.nHealing = 0

	self.flZoneCleanupTime = 99999.9

	self.PlayerStats = {}

	self.SpawnGroups = {}
	self.Enemies = {}
	self.Bosses = {}

	self.szName = data.szName
	self.nZoneID = data.nZoneID
	self.bVictoryOnComplete = data.bVictoryOnComplete
	self.szTeleportEntityName = data.szTeleportEntityName or nil
	self.vTeleportPos = data.vTeleportPos or nil
	self.Type = data.Type
	self.Quests = data.Quests

	self.StarCriteria = data.StarCriteria or nil
	self.nXPRemaining = data.MaxZoneXP or 0 
	self.nMaxZoneXP = data.MaxZoneXP or 1
	self.nGoldRemaining = data.MaxZoneGold or 0
	self.nMaxZoneGold = data.MaxZoneGold or 1
	self.bNoLeaderboard = data.bNoLeaderboard or false
	self.bDropsDisabled = false
	self.hZoneTrigger = Entities:FindByName( nil, "zonevolume_" .. self.szName )
	self.hZoneCheckpoint = Entities:FindByName( nil, self.szName .. "_checkpoint_building" )
	self.nPrecacheCount = 0
	self.nExpectedSquadNPCCount = 0
	self.bSpawnedSquads = false
	self.bSpawnedChests = false
	self.bSpawnedBreakables = false
	self.Squads = data.Squads or {}
	self.Chests = data.Chests or {}
	self.Breakables = data.Breakables or {}
	self.nVIPsKilled = 0
	self.VIPsAlive = {}
	self.VIPs = data.VIPs or {}
	self.Neutrals = data.Neutrals or {}
	self.NeutralsAlive = {}

	if self.hZoneTrigger == nil then
		print( "CDungeonZone:Init() - ERROR - No Zone Volume found for zone " .. self.szName )
	end

	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil then
			quest.bActivated = false
			quest.bCompleted = false
			quest.nCompleted = 0
			quest.bOptional = quest.bOptional or false
			if quest.nCompleteLimit == nil then
				quest.nCompleteLimit = 1
			end
		end
	end

	self.PlayerStats = {}

	for nPlayerID = 0,3 do
		self.PlayerStats[nPlayerID] = {}
		self.PlayerStats[nPlayerID]["Kills"] = 0
		self.PlayerStats[nPlayerID]["Items"] = 0
		self.PlayerStats[nPlayerID]["GoldBags"] = 0
		self.PlayerStats[nPlayerID]["Potions"] = 0
		self.PlayerStats[nPlayerID]["ReviveTime"] = 0
		self.PlayerStats[nPlayerID]["Damage"] = 0
		self.PlayerStats[nPlayerID]["Healing"] = 0
		self.PlayerStats[nPlayerID]["Deaths"] = 0
	end

	if self.Type == ZONE_TYPE_SURVIVAL then
		self.Survival = data.Survival
		self.Survival.bStarted = false
		self.Survival.flTimeOfNextAttack = 0
	end

	if self.Type == ZONE_TYPE_HOLDOUT then
		self.Holdout = data.Holdout
		self.Holdout.bStarted = false
		self.Holdout.bCompleted = false

		self.nCurrentWave = 0
		self.flTimeOfNextSpawn = 0
		self.flTimeOfNextWave = 0

		self.Waves = data.Holdout.Waves
		self.Spawners = data.Holdout.Spawners
		self.nVIPDeathsAllowed = data.Holdout.nVIPDeathsAllowed or 0
	end

	if self.Type == ZONE_TYPE_ASSAULT then
		self.Assault = data.Assault
		self.Assault.bStarted = false
		self.Assault.bCompleted = false
	end
end

--------------------------------------------------------------------

function CDungeonZone:Precache()
	--print( "CDungeonZone:Precache - Precaching Zone " .. self.szName )
	if self.bPrecached == true then
		return
	end

	self.nPrecacheCount = 0
	
	self:PrecacheNPCs( self.Squads.Fixed )
	self:PrecacheNPCs( self.Squads.Random )
	self:PrecacheVIPs( self.VIPs )
	self:PrecacheNeutrals( self.Neutrals )

	if self.Type == ZONE_TYPE_SURVIVAL then	
		if self.Squads.Chasing ~= nil then
			self:PrecacheNPCs( self.Squads.Chasing )
		end
	end

	if self.Type == ZONE_TYPE_HOLDOUT then
		self:PrecacheNPCs( self.Waves )
	end

	if self.Type == ZONE_TYPE_ASSAULT then
		if self.Squads.Chasing ~= nil then
			self:PrecacheNPCs( self.Squads.Chasing )
		end
		self:PrecacheNPCs( self.Assault.Attackers )
	end

	self.bPrecached = true
end

--------------------------------------------------------------------

function CDungeonZone:PrecacheNPCs( zoneTable )
	local nNPCCount = 0

	if zoneTable == nil then
		return
	end
	
	for _, npcTable in pairs( zoneTable ) do
		if npcTable ~= nil then
		--	print( "CDungeonZone:PrecacheEnemies() - Precaching squad " .. tostring( enemyTable ) )
			for _, unitTable in pairs( npcTable["NPCs"] ) do
				if unitTable ~= nil then
					nNPCCount = nNPCCount + unitTable.nCount
					local bFound = false
					for _,precachedNPC in pairs ( GameRules.Dungeon.PrecachedEnemies ) do
						if precachedNPC == unitTable.szNPCName then
							bFound = true
						end
					end
					if bFound == false then
						self.nPrecacheCount = self.nPrecacheCount + 1
						PrecacheUnitByNameAsync( unitTable.szNPCName, function( sg ) table.insert( self.SpawnGroups, sg ) end )
						table.insert( GameRules.Dungeon.PrecachedEnemies, unitTable.szNPCName )
						--print( "CDungeonZone:PrecacheNPCs() - Precached unit of type " .. unitTable.szNPCName )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:PrecacheVIPs( vipTable )
	if vipTable == nil or #vipTable == 0 then
		return
	end

	local nVIPCount = 0
	self.nPrecacheVIPCount = 0
	
	--print( "CDungeonZone:PrecacheVIPs() - Precaching VIPs " .. tostring( vipTable ) )
	for _, unitTable in pairs( vipTable ) do
		if unitTable ~= nil then
			nVIPCount = nVIPCount + unitTable.nCount
			local bFound = false
			for _, precachedVIP in pairs ( GameRules.Dungeon.PrecachedVIPs ) do
				if precachedVIP == unitTable.szVIPName then
					bFound = true
				end
			end
			if bFound == false then
				self.nPrecacheVIPCount = self.nPrecacheVIPCount + 1
				PrecacheUnitByNameAsync( unitTable.szVIPName, function( sg ) table.insert( self.SpawnGroups, sg ) end )
				table.insert( GameRules.Dungeon.PrecachedVIPs, unitTable.szVIPName )
				--print( "CDungeonZone:PrecacheVIPs() - Precached unit of type " .. unitTable.szVIPName )
			end
		end
	end
	--print( "CDungeonZone:PrecacheVIPs() - There are " .. self.nPrecacheVIPCount .. " VIP types in zone." )
end

--------------------------------------------------------------------

function CDungeonZone:PrecacheNeutrals( neutralTable )
	if neutralTable == nil or #neutralTable == 0 then
		return
	end

	--print( "CDungeonZone:PrecacheNeutrals() - Precaching Neutrals " .. tostring( neutralTable ) )
	for _, unitTable in pairs( neutralTable ) do
		if unitTable ~= nil then
			PrecacheUnitByNameAsync( unitTable.szNPCName, function( sg ) table.insert( self.SpawnGroups, sg ) end )
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnSquadCreatures( bAsync )
	if self.bSpawnedSquads == true then
		return
	end

	self.bSpawnedSquads = true
	self.nExpectedSquadNPCCount = 0
	--print( "-----------------------------------" )
	if self.Squads.Fixed ~= nil then
		--print( "CDungeonZone:SpawnSquadCreatures() - Spawning Fixed Squads" )
		for _, squadTable in pairs( self.Squads.Fixed ) do
			if ( squadTable.szSpawnerName == nil ) then
				print( "CDungeonZone:SpawnSquadCreatures() - ERROR: No spawnerName specified for this squad type" )
				return
			end

			local hSpawners = Entities:FindAllByName( squadTable.szSpawnerName )
			--print( "Found " .. #hSpawners .. " map spawners." )

			for _, hSpawner in pairs( hSpawners ) do
				hSpawner.tSquadMembers = {}
				for _, npc in pairs( squadTable.NPCs ) do
					for k = 1, npc.nCount do
						local hUnit = self:SpawnSquadUnit( npc, DOTA_TEAM_BADGUYS, hSpawner, "SquadState", squadTable.nMaxSpawnDistance, bAsync )

						-- Add unit to the hSpawner's squad members table
						table.insert( hSpawner.tSquadMembers, hUnit )
					end
					self.nExpectedSquadNPCCount = self.nExpectedSquadNPCCount + npc.nCount
				end
			end
		end
	end
	

	if self.Squads.Random ~= nil then
		--print( "CDungeonZone:SpawnSquadCreatures() - Spawning Random Squads" )
		local hSpawnerList = {}
		for _, squadTable in pairs( self.Squads.Random ) do
			if ( squadTable.szSpawnerName == nil ) then
				print( "CDungeonZone:SpawnSquadCreatures() - ERROR: No spawnerName specified for this squad type" )
				return
			end

			local hSpawners = Entities:FindAllByName( squadTable.szSpawnerName )
			for _, hSpawner in pairs( hSpawners ) do
				local bRepeated = false
				for _,UsedSpawner in pairs( hSpawnerList ) do
					if UsedSpawner == hSpawner then
						bRepeated = true
					end
				end

				if not bRepeated then
					table.insert( hSpawnerList, hSpawner )
				end
			end
		end

		for _,squadTable in pairs( self.Squads.Random ) do
			local nIndex = RandomInt( 1, #hSpawnerList )
			local hSpawnerToUse = hSpawnerList[ nIndex ]
			if hSpawnerToUse ~= nil then
				for _, npc in pairs( squadTable.NPCs ) do
					for k = 1, npc.nCount do
						local hUnit = self:SpawnSquadUnit( npc, DOTA_TEAM_BADGUYS, hSpawnerToUse, "SquadState", squadTable.nMaxSpawnDistance, bAsync )

						-- Add unit to the hSpawner's squad members table
					--	table.insert( hSpawner.tSquadMembers, hUnit )
					end
					self.nExpectedSquadNPCCount = self.nExpectedSquadNPCCount + npc.nCount
				end

				table.remove( hSpawnerList, nIndex )
			end 
		end
	end
end

--------------------------------------------------------------------------------

function CDungeonZone:SpawnSquadUnit( npcData, nTeam, hSpawner, sState, nMaxSpawnDistance, bAsync )
	local vSpawnerPos = hSpawner:GetOrigin()
	if nMaxSpawnDistance == nil then
		nMaxSpawnDistance = 0
	end
	local vUnitSpawnPos = vSpawnerPos + RandomVector( RandomFloat( 25, nMaxSpawnDistance ) )

	local nAttempts = 0
	-- Verify path is clear from spawner to desired spawn loc (give up after a few, so we can't get stuck)
	while ( ( not GridNav:CanFindPath( vSpawnerPos, vUnitSpawnPos ) ) and ( nAttempts < 5 ) ) do
		vUnitSpawnPos = vSpawnerPos + RandomVector( RandomFloat( 25, nMaxSpawnDistance ) )
		nAttempts = nAttempts + 1
		--print( "Verify path is clear from spawner to desired spawn loc, attempt #" .. nAttempts )
	end

	if bAsync then
		CreateUnitByNameAsync( npcData.szNPCName, vUnitSpawnPos, true, nil, nil, nTeam, 
			function( hUnit ) 
			--	print( hUnit )
			--	print( hUnit:GetUnitName() )
				hUnit.sState = sState
				if npcData.bBoss == true then	
					hUnit.bBoss = true
					hUnit.bStarted = false
				end
				self:AddEnemyToZone( hUnit )
				if npcData.bUseSpawnerFaceAngle == true then
					local vSpawnerForward = hSpawner:GetForwardVector()
					hUnit:SetForwardVector( vSpawnerForward )
				else
					hUnit:FaceTowards( hSpawner:GetOrigin() )
				end
				

				if #self.Enemies == self.nExpectedSquadNPCCount then
					--print( "CDungeonZone:SpawnSquadUnit() - Async Spawning Complete.  There are " .. #self.Enemies .. " enemies in zone." )
				end
				
			end )
	else
		local hUnit = CreateUnitByName( npcData.szNPCName, vUnitSpawnPos, true, nil, nil, nTeam )
		hUnit.sState = sState
		if npcData.bBoss == true then
			hUnit.bBoss = true
			hUnit.bStarted = false
		end
		self:AddEnemyToZone( hUnit )
		if npcData.bUseSpawnerFaceAngle == true then
			local vSpawnerForward = hSpawner:GetForwardVector()
			hUnit:SetForwardVector( vSpawnerForward )
		else
			hUnit:FaceTowards( hSpawner:GetOrigin() )
		end
	    return hUnit
	end
end

--------------------------------------------------------------------------------

function CDungeonZone:SpawnChests()
	if self.bSpawnedChests == true then
		return
	end

	self.bSpawnedChests = true

	--print( "-----------------------------------" )
	--print( "CDungeonZone:SpawnChests()" )

	--print( string.format( "There are %d chest tables in zone \"%s\"", #self.Chests, self.szName ) )
	--PrintTable( self.Chests, "   " )

	for index, chestTable in ipairs( self.Chests ) do
		--print( "" )
		--print( "Looking at chestTable #" .. index )
		if ( chestTable.szSpawnerName == nil ) then
			print( string.format( "CDungeonZone:SpawnChests() - ERROR: No szSpawnerName specified for this chest. [Zone: \"%s\"]", self.szName ) )
		end

		local fSpawnChance = chestTable.fSpawnChance
		if fSpawnChance == nil or fSpawnChance <= 0 then
			print( string.format( "CDungeonZone:SpawnChests - ERROR: Treasure chest spawn chance is not valid [Zone: \"%s\"]", self.szName ) )
		end

		if chestTable.nMaxSpawnDistance == nil or chestTable.nMaxSpawnDistance < 0 then
			print( string.format( "CDungeonZone:SpawnChests - WARNING: nMaxSpawnDistance is not valid. Defaulting to 0. [Zone: \"%s\"]", self.szName ) )
			chestTable.nMaxSpawnDistance = 0
		end

		if ( chestTable.szSpawnerName ~= nil ) then
			--print( "chestTable.szSpawnerName == " .. chestTable.szSpawnerName )
			local hSpawners = Entities:FindAllByName( chestTable.szSpawnerName )
			for _, hSpawner in pairs( hSpawners ) do
				local vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, chestTable.nMaxSpawnDistance ) )
				-- Roll dice to determine whether to spawn chest at this spawner
				local fThreshold = 1 - fSpawnChance
				local bSpawnChest = RandomFloat( 0, 1 ) >= fThreshold
				if bSpawnChest then
					local hUnit = CreateUnitByName( chestTable.szNPCName, vSpawnLoc, true, nil, nil, DOTA_TEAM_GOODGUYS )
					if hUnit ~= nil then
						local vSpawnerForward = hSpawner:GetForwardVector()
						hUnit:SetForwardVector( vSpawnerForward )

						--print( "Created chest unit named " .. hUnit:GetUnitName() )
						hUnit.zone = self
						hUnit.Items = chestTable.Items
						hUnit.fItemChance = chestTable.fItemChance
						hUnit.Relics = chestTable.Relics
						hUnit.fRelicChance = chestTable.fRelicChance
						hUnit.nMinGold = chestTable.nMinGold
						hUnit.nMaxGold = chestTable.nMaxGold
						hUnit.szTraps = chestTable.szTraps
						hUnit.nTrapLevel = chestTable.nTrapLevel

						self:AddTreasureChestToZone( hUnit )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnBreakables()
	if self.bSpawnedBreakables == true then
		return
	end

	self.bSpawnedBreakables = true

	--print( "-----------------------------------" )
	--print( "CDungeonZone:SpawnBreakables()" )
	--print( string.format( "There are %d breakable tables in zone \"%s\"", #self.Breakables, self.szName ) )
	--PrintTable( self.Breakables, "   " )

	for index, breakableTable in ipairs( self.Breakables ) do
		--print( "" )
		--print( "Looking at breakableTable #" .. index )
		if ( breakableTable.szSpawnerName == nil ) then
			print( string.format( "CDungeonZone:SpawnBreakables() - ERROR: No szSpawnerName specified for this breakable container. [Zone: \"%s\"]", self.szName ) )
		end

		local fSpawnChance = breakableTable.fSpawnChance
		if fSpawnChance == nil or fSpawnChance <= 0 then
			print( string.format( "CDungeonZone:SpawnBreakables - ERROR: Breakable container spawn chance is not valid [Zone: \"%s\"]", self.szName ) )
		end

		if breakableTable.nMaxSpawnDistance == nil or breakableTable.nMaxSpawnDistance < 0 then
			print( string.format( "CDungeonZone:SpawnBreakables - WARNING: nMaxSpawnDistance is not valid. Defaulting to 0. [Zone: \"%s\"]", self.szName ) )
			breakableTable.nMaxSpawnDistance = 0
		end

		if ( breakableTable.szSpawnerName ~= nil ) then
			--print( "breakableTable.szSpawnerName == " .. breakableTable.szSpawnerName )
			local hSpawners = Entities:FindAllByName( breakableTable.szSpawnerName )
			for _, hSpawner in pairs( hSpawners ) do
				local vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, breakableTable.nMaxSpawnDistance ) )
				-- Roll dice to determine whether to spawn breakable at this spawner
				local fThreshold = 1 - fSpawnChance
				local bSpawnBreakable = RandomFloat( 0, 1 ) >= fThreshold
				if bSpawnBreakable then
					local hUnit = CreateUnitByName( breakableTable.szNPCName, vSpawnLoc, true, nil, nil, DOTA_TEAM_BADGUYS )
					if hUnit ~= nil then
						local vSpawnerForward = hSpawner:GetForwardVector()
						hUnit:SetForwardVector( vSpawnerForward )

						--print( "Created breakable container unit named " .. hUnit:GetUnitName() )
						hUnit.zone = self
						hUnit.CommonItems = breakableTable.CommonItems
						hUnit.fCommonItemChance = breakableTable.fCommonItemChance
						hUnit.RareItems = breakableTable.RareItems
						hUnit.fRareItemChance = breakableTable.fRareItemChance
						hUnit.nMinGold = breakableTable.nMinGold
						hUnit.nMaxGold = breakableTable.nMaxGold
						hUnit.fGoldChance = breakableTable.fGoldChance

						self:AddBreakableContainerToZone( hUnit )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnVIPs( vipsTable )
	--print( "-----------------------------------" )
	--print( "CDungeonZone:SpawnVIPs()" )
	if vipsTable == nil then
		print( "CDungeonZone:SpawnVIPs() - ERROR: No VIPs Table" )
		return
	end

	for _, vip in pairs ( vipsTable ) do
		local hSpawner = Entities:FindByName( nil, vip.szSpawnerName )
		if hSpawner == nil then
			print( "CDungeonZone:SpawnVIPs() - ERROR: No Spawners found" )
			return
		end

		if hSpawner ~= nil then
			--print( "CDungeonZone:SpawnVIPs() - Spawning " .. vip.nCount .. " " .. vip.szVIPName )

			if vip.nSpawnAmt == nil then
				vip.nSpawnAmt = 0
			end

			if ( vip.nMaxSpawnCount == nil ) or ( vip.nSpawnAmt < vip.nMaxSpawnCount ) then
				for i=1,vip.nCount do
					local hUnit = CreateUnitByName( vip.szVIPName, hSpawner:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
					if hUnit ~= nil then
						hUnit.zone = self
						hUnit.isInHoldout = true
						hUnit:AddNewModifier( hUnit, nil, "modifier_npc_dialog", { duration = -1 } )
						local hAnimationBuff = hUnit:AddNewModifier( hUnit, nil, "modifier_stack_count_animation_controller", {} )
						if hAnimationBuff ~= nil and vip.Activity ~= nil then
							hAnimationBuff:SetStackCount( vip.Activity )
						end
						hUnit.bRequired = vip.bRequired or false
						
						local vSpawnerForward = hSpawner:GetForwardVector()
						hUnit:SetForwardVector( vSpawnerForward )

						if vip.szWaypointName then
							local hWaypoint = nil
							hWaypoint = Entities:FindByName( nil, vip.szWaypointName )
							if hWaypoint ~= nil then
								hUnit:SetInitialGoalEntity( hWaypoint )
							end
						end

						vip.nSpawnAmt = vip.nSpawnAmt + 1
						table.insert( self.VIPsAlive, hUnit )
					else
						print( "CDungeonZone:SpawnVIPs() - ERROR: Unit spawning of unit " .. vip.szVIPName .. " failed" )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnNeutrals( NeutralsTable )
	--print( "-----------------------------------" )
	--print( "CDungeonZone:SpawnNeutrals()" )
	if NeutralsTable == nil then
		print( "CDungeonZone:SpawnNeutrals() - ERROR: No Neutrals Table" )
		return
	end

	for _, neutral in pairs ( NeutralsTable ) do
		local hSpawner = Entities:FindByName( nil, neutral.szSpawnerName )
		if hSpawner == nil then
			print( "CDungeonZone:SpawnNeutrals() - ERROR: No Spawners named " .. neutral.szSpawnerName .. " found" )
		else
			--print( "CDungeonZone:SpawnNeutrals() - Spawning " .. neutral.nCount .. " " .. neutral.szNPCName )

			if neutral.nSpawnAmt == nil then
				neutral.nSpawnAmt = 0
			end

			if ( neutral.nMaxSpawnCount == nil ) or ( neutral.nSpawnAmt < neutral.nMaxSpawnCount ) then
				for i=1,neutral.nCount do
					local hUnit = CreateUnitByName( neutral.szNPCName, hSpawner:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
					if hUnit ~= nil then
						hUnit.zone = self
						hUnit.isInHoldout = true
						hUnit:AddNewModifier( hUnit, nil, "modifier_npc_dialog", { duration = -1 } )
						local hAnimationBuff = hUnit:AddNewModifier( hUnit, nil, "modifier_stack_count_animation_controller", {} )
						if hAnimationBuff ~= nil and neutral.Activity ~= nil then
							hAnimationBuff:SetStackCount( neutral.Activity )
						end
						--hack
						if hUnit:GetUnitName() == "npc_dota_creature_invoker" then
							hUnit:RemoveModifierByName( "modifier_stack_count_animation_controller" )
							hUnit:AddNewModifier( hUnit, nil, "modifier_invoker_juggle", { duration = -1 } );
						end

						hUnit.bRequired = neutral.bRequired or false
						
						local vSpawnerForward = hSpawner:GetForwardVector()
						hUnit:SetForwardVector( vSpawnerForward )

						if neutral.szWaypointName then
							local hWaypoint = nil
							hWaypoint = Entities:FindByName( nil, neutral.szWaypointName )
							if hWaypoint ~= nil then
								hUnit:SetInitialGoalEntity( hWaypoint )
								hUnit:AddNewModifier( hUnit, nil, "modifier_followthrough", { duration = 1.0 } ) -- maybe this fixes NPC staying in his idle state
							end
						end

						neutral.nSpawnAmt = neutral.nSpawnAmt + 1
						table.insert( self.NeutralsAlive, hUnit )
					else
						print( "CDungeonZone:SpawnNeutrals() - ERROR: Unit spawning of unit " .. neutral.szNPCName .. " failed" )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnChasingSquads( nCount, nTeamNumber, ChaserSquads, ChaserSpawners, SquadPool, bNoRepeat )
	if self:InBossFight() then
	--	print( "CDungeonZone:SpawnChasingSquads() - Aborting Spawn, boss fight is active." )
		return
	end
	
	if ChaserSquads == nil or ChaserSpawners == nil or SquadPool == nil then
		print( "CDungeonZone:SpawnChasingSquads() - ERROR: Squads or Spawners are nil" )
		return
	end

	EmitAnnouncerSound( "Dungeon.ChaserSpawn" )

	local SelectedSpawners = {}
	local RemainingSquads = shallowcopy( ChaserSquads )
	for i=1,nCount do 
		local nSelectedSquadIndex = RandomInt( 1, #RemainingSquads )
		local szChaserSquadName = RemainingSquads[nSelectedSquadIndex]
		if szChaserSquadName == nil then
			print( "CDungeonZone:SpawnChasingSquads() - ERROR: No Chaser Squad Name" )
			return
		end

		if bNoRepeat then
			if #RemainingSquads == 1 and i < nCount then
				print( "CDungeonZone:SpawnChasingSquads() - ERROR: There are " .. nCount - i .. " too few squads defined" )
			end
			table.remove( RemainingSquads, nSelectedSquadIndex )
		--	print( "CDungeonZone:SpawnChasingSquads() - No Repeat set, removing squad named " .. szChaserSquadName )
		end

		local ChaserSquad = SquadPool.Fixed[szChaserSquadName]
		if ChaserSquad == nil then
			--Look in random
			ChaserSquad = SquadPool.Random[szChaserSquadName]
			if ChaserSquad == nil then
				-- Look in Attackers
				ChaserSquad = SquadPool.Chasing[szChaserSquadName]
				if ChaserSquad == nil then
					print( "CDungeonZone:SpawnChasingSquads() - ERROR: No Chaser Squad named " .. szChaserSquadName  )
					return
				end
			end
		end

		local vCenterOfHeroes = nil
		local Heroes = HeroList:GetAllHeroes()
		if #Heroes == 0 then
			print( "CDungeonZone:SpawnChasingSquads() - ERROR: No Heroes" )
			return
		end

		for _,hero in ipairs( Heroes ) do
			if hero ~= nil and hero:IsRealHero() and hero:IsAlive() then
				if vCenterOfHeroes == nil then
					vCenterOfHeroes = hero:GetOrigin()
				else
					vCenterOfHeroes = vCenterOfHeroes + hero:GetOrigin()
				end
			end
		end

		if vCenterOfHeroes == nil then
		--	print( "CDungeonZone:SpawnChasingSquads() - All heroes dead, skip chasing spawn." )
			return
		end
			
		vCenterOfHeroes = vCenterOfHeroes / #Heroes

		local hNearestHiddenSpawner = nil
		local flClosestDist = 10000 
		local flMinDist = 1500
		for _, szSpawnerName in pairs( ChaserSpawners ) do
		--	print( "CDungeonZone:SpawnChasingSquads() - Calculating Distance of " .. szSpawnerName )
			local hSpawners = Entities:FindAllByName( szSpawnerName )
		--	print( "CDungeonZone:SpawnChasingSquads() - #hSpawners == " .. #hSpawners )
			if hSpawners == nil or #hSpawners == 0 then
				print( "CDungeonZone:SpawnChasingSquads() - ERROR: No Spawner Found Named: " .. szSpawnerName )
			else
				--print( "Found " .. #hSpawners .. " spawners" )
				for _, spawner in pairs( hSpawners ) do
					local bUsed = false
					for _, UsedSpawners in pairs( SelectedSpawners ) do
						if UsedSpawners == spawner then
							bUsed = true
						end
					end

					if not IsLocationVisible( DOTA_TEAM_GOODGUYS, spawner:GetOrigin() ) then
						local flSpawnerDist = ( spawner:GetOrigin() - vCenterOfHeroes ):Length2D()
						if ( not bUsed ) and ( flSpawnerDist < flClosestDist ) and ( flSpawnerDist > flMinDist ) then
						--	print( "   this spawner's distance of " .. flSpawnerDist .. " is closer than our previous closest distance of " .. flClosestDist )
							flClosestDist = flSpawnerDist 
							hNearestHiddenSpawner = spawner
						end
					end
				end		
			end	
		end

		if hNearestHiddenSpawner == nil then
			print( "CDungeonZone:SpawnChasingSquads() - ERROR: No Nearest Hidden Spawner Found" )
			return
		end


		local NPCs = ChaserSquad.NPCs
		if NPCs == nil then
			print( "CDungeonZone:SpawnChasingSquads() - ERROR: No NPCs Table" )
			return
		end

		--print( "Spawn Squad " .. szAttackerSquad .. " at " .. hNearestHiddenSpawner:GetName() )
		for _,npc in pairs ( NPCs ) do
			for i=1,npc.nCount do
				local hUnit = CreateUnitByName( npc.szNPCName, hNearestHiddenSpawner:GetOrigin(), true, nil, nil, nTeamNumber )
				if hUnit ~= nil then
					hUnit.bAttacker = true
					if nTeamNumber == DOTA_TEAM_BADGUYS then
						self:AddEnemyToZone( hUnit )
					end
					
					local hAttackTarget = nil
					
					for i=1,#Heroes do 
						if hAttackTarget == nil then
							hAttackTarget = Heroes[ RandomInt( 1, #Heroes ) ]
							if hAttackTarget ~= nil and self:ContainsUnit( hAttackTarget ) and ( hAttackTarget:IsRealHero() == false or hAttackTarget:IsAlive() == false ) then
								hAttackTarget = nil
							end 
						end
					end
					if hAttackTarget ~= nil then
						hUnit:SetInitialGoalEntity( hAttackTarget )
						hUnit:SetContextThink( string.format( "Chaser_aiThink_%s", hUnit:entindex() ), function() return Chaser_aiThink( self, hUnit ) end, 0 )
					else
						print( "CDungeonZone:SpawnChasingSquads() - ERROR: No Valid Attacker Target Found" )
					end	

					if self.bDropsDisabled then
						hUnit:RemoveAllItemDrops()
					end

				else
					print( "CDungeonZone:SpawnChasingSquads() - ERROR: Spawning of unit " .. npc.szNPCName .. " failed" )
				end
			end
		end

		table.insert( SelectedSpawners, hNearestHiddenSpawner )
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnPathingSquads( waveTable, nTeamNumber )
	--print( "-----------------------------------" )
	--print( "CDungeonZone:SpawnPathingSquads()" )
	if waveTable == nil then
		print( "CDungeonZone:SpawnPathingSquads() - ERROR: No Wave Table" )
		return
	end

	local NPCs = waveTable.NPCs
	if NPCs == nil then
		print( "CDungeonZone:SpawnPathingSquads() - ERROR: No NPCs Table" )
		return
	end

	for _,npc in pairs ( NPCs ) do
		if npc.flDelay ~= nil then
			--print( "CDungeonZone:SpawnPathingSquads() - NPC " .. npc.szNPCName .. " has " .. npc.flDelay .. " seconds remaining before spawning." )
			npc.flDelay = npc.flDelay - waveTable.flSpawnInterval			
			if npc.flDelay <= 0.0 then
				npc.flDelay = nil
			end
		end

		if npc.flDelay == nil then
			local hSpawner = Entities:FindByName( nil, npc.szSpawnerName )
			local hWaypoint = Entities:FindByName( nil, npc.szWaypointName )
			if hWaypoint == nil or hSpawner == nil then
				if hWaypoint == nil then
					for _,VIP in pairs( self.VIPsAlive ) do
						if VIP ~= nil and VIP:GetUnitName() == npc.szWaypointName then
							hWaypoint = VIP
						end
					end
					if hWaypoint == nil then
						print( "CDungeonZone:SpawnPathingSquads() - ERROR: No Waypoint Found" )
					end
				end

				if hSpawner == nil then
					if #self.Spawners == 0 then
						print( "CDungeonZone:SpawnPathingSquads() - ERROR: No Specific or Random Spawners Defined" )
					else
						local SpawnerData = self.Spawners[ RandomInt( 1, #self.Spawners ) ]
						if SpawnerData ~= nil then
							hSpawner = Entities:FindByName( nil, SpawnerData.szSpawnerName )
							hWaypoint = Entities:FindByName( nil, SpawnerData.szWaypointName )
						else
							print( "CDungeonZone:SpawnPathingSquads() - ERROR: Choosing random spawner and waypoint failed" )
						end
					end
				end
			end

			if hSpawner ~= nil and hWaypoint ~= nil then
				if npc.nSpawnAmt == nil then
					npc.nSpawnAmt = 0
				end
				if ( npc.nMaxSpawnCount == nil ) or ( npc.nSpawnAmt < npc.nMaxSpawnCount ) then
					for i=1,npc.nCount do
						local hUnit = CreateUnitByName( npc.szNPCName, hSpawner:GetOrigin(), true, nil, nil, nTeamNumber )
						if hUnit ~= nil then
							
							hUnit.isInHoldout = true

							--This might seem weird, but it's so we can move the bounty into gold bags and zone xp distribution and maintain limits
						
							hUnit.bBoss	= npc.bBoss or false	
							hUnit.bStarted = false	
							if nTeamNumber == DOTA_TEAM_BADGUYS then
								self:AddEnemyToZone( hUnit )
							end

							if not npc.bDontSetGoalEntity then
								hUnit:SetInitialGoalEntity( hWaypoint )
							end
							npc.nSpawnAmt = npc.nSpawnAmt + 1
						else
							print( "CDungeonZone:SpawnPathingSquads() - ERROR: Unit spawning of unit " .. npc.szNPCName .. " failed" )
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:Activate()
	if self.bActivated == true or self.bZoneCompleted == true then
		return
	end

	if self.flTimeOfFirstActivation == nil then
		self.flTimeOfFirstActivation = GameRules:GetGameTime() 
	end

	if self.bSpawnedSquads == false and #self.Squads > 0 then
		self:SpawnSquadCreatures( false )
	end

	--print( string.format( "self.bSpawnedChests == %s, #self.Chests == %d", tostring( self.bSpawnedChests ), #self.Chests ) )
	if self.bSpawnedChests == false and #self.Chests > 0 then
		self:SpawnChests()
	end

	if self.bSpawnedBreakables == false and self.Breakables and #self.Breakables > 0 then
		self:SpawnBreakables()
	end

	if not self.bSpawnedVIPs then
		self:SpawnVIPs( self.VIPs )
		self:SpawnNeutrals( self.Neutrals )
		self.bSpawnedVIPs = true
	end

	--print( "CDungeonZone:Activate - Zone " .. self.szName .. " is being activated" )
	GameRules.Dungeon:OnZoneActivated( self )

	if self.Type == ZONE_TYPE_SURVIVAL then
		if self.Survival.StartQuest == nil then
			self:SurvivalStart()
		end
	end

	if self.Type == ZONE_TYPE_HOLDOUT then
		if self.Holdout.StartQuest == nil then
			self:HoldoutStart()
		end
	end

	if self.Type == ZONE_TYPE_ASSAULT then
		if self.Assault.StartQuest == nil then
			self:AssaultStart()
		end
	end
	self.bActivated = true
end

--------------------------------------------------------------------

function CDungeonZone:OnZoneActivated( zone )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and quest.bCompleted == false then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_ZONE_ACTIVATE and activator.szZoneName == zone.szName then
						bShouldActivate = true
					end

					if activator.Type == QUEST_EVENT_ON_DIALOG or activator.Type == QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED and zone.szName == self.szName then
						local hDialogEntities = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
						for _,DialogEnt in pairs ( hDialogEntities ) do
							if DialogEnt ~= nil  and DialogEnt:GetUnitName() == activator.szNPCName and DialogEnt:FindModifierByName( "modifier_npc_dialog_notify" ) == nil then
								DialogEnt:AddNewModifier( DialogEnt, nil, "modifier_npc_dialog_notify", {} )
							end
						end
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_ZONE_ACTIVATE and quest.Completion.szZoneName == zone.szName then
				GameRules.Dungeon:OnQuestCompleted( self, quest )
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnZoneEventComplete( zone )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and not quest.bCompleted == true then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_ZONE_EVENT_FINISHED and activator.szZoneName == zone.szName then
						bShouldActivate = true
					end
				end
				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_ZONE_EVENT_FINISHED and quest.Completion.szZoneName == zone.szName then
				GameRules.Dungeon:OnQuestCompleted( self, quest )
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnEnemyKilled( hDeadEnemy, Zone )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and not quest.bCompleted == true then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_ENEMY_KILLED and activator.szNPCName == hDeadEnemy:GetUnitName() and ( ( quest.Completion.szZoneName == Zone.szName ) or ( quest.Completion.szZoneName == nil ) ) then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_ENEMY_KILLED and quest.Completion.szNPCName == hDeadEnemy:GetUnitName() and ( ( quest.Completion.szZoneName == Zone.szName ) or ( quest.Completion.szZoneName == nil ) ) then
				GameRules.Dungeon:OnQuestCompleted( self, quest ) 
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnTreasureOpened( szZoneName )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and not quest.bCompleted == true then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_TREASURE_OPENED and activator.szZoneName == szZoneName then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_TREASURE_OPENED and quest.Completion.szZoneName == szZoneName then
				GameRules.Dungeon:OnQuestCompleted( self, quest ) 
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnKeyItemPickedUp( szZoneName, szItemName )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and not quest.bCompleted == true then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_KEY_ITEM_RECEIVED and activator.szItemName == szItemName and activator.szZoneName == szZoneName then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_KEY_ITEM_RECEIVED and quest.Completion.szItemName == szItemName and quest.Completion.szZoneName == szZoneName then
				GameRules.Dungeon:OnQuestCompleted( self, quest ) 
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnDialogBegin( hDialogEnt )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and not quest.bCompleted == true then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_DIALOG and activator.szNPCName == hDialogEnt:GetUnitName() and hDialogEnt.nCurrentLine == activator.nDialogLine then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_DIALOG and quest.Completion.szNPCName == hDialogEnt:GetUnitName() and hDialogEnt.nCurrentLine == quest.Completion.nDialogLine then
				GameRules.Dungeon:OnQuestCompleted( self, quest ) 
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnDialogAllConfirmed( hDialogEnt, nDialogLine )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and not quest.bCompleted == true then
			if quest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( quest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED and hDialogEnt ~= nil and activator.szNPCName == hDialogEnt:GetUnitName() and nDialogLine == activator.nDialogLine then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, quest )
				end
			end

			if quest.bActivated == true and quest.Completion.Type == QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED and hDialogEnt ~= nil and quest.Completion.szNPCName == hDialogEnt:GetUnitName() and nDialogLine == quest.Completion.nDialogLine then
				GameRules.Dungeon:OnQuestCompleted( self, quest ) 
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:StartQuestByName( szQuestName )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and quest.szQuestName == szQuestName then
			if quest.bActivated == true then
				print( "CDungeonZone:StartQuestByName - ERROR: Quest " .. szQuestName .. " has already started." )
			end
			if quest.bCompleted == true then
				print( "CDungeonZone:StartQuestByName - ERROR: Quest " .. szQuestName .. " has already finished." )
			end
			
			GameRules.Dungeon:OnQuestStarted( self, quest )
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:IsQuestActive( szQuestName )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and quest.szQuestName == szQuestName then
			if quest.bActivated == true and quest.bCompleted == false then
				return true
			end
		end
	end

	return false
end

--------------------------------------------------------------------

function CDungeonZone:IsQuestComplete( szQuestName )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and quest.szQuestName == szQuestName then
			if quest.bCompleted == true then
				return true
			end
		end
	end

	return false
end

--------------------------------------------------------------------

function CDungeonZone:GetQuestCompleteCount( szQuestName )
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and quest.szQuestName == szQuestName then
			return quest.nCompleted
		end
	end

	return -1
end

--------------------------------------------------------------------

function CDungeonZone:OnQuestStarted( quest )
	for _,zoneQuest in pairs ( self.Quests ) do
		if zoneQuest ~= nil and not zoneQuest.bCompleted == true then
			if zoneQuest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( zoneQuest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_QUEST_ACTIVATE and activator.szQuestName == quest.szQuestName then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, zoneQuest )
				end
			end

			if zoneQuest.bActivated == true and zoneQuest.Completion.Type == QUEST_EVENT_ON_QUEST_ACTIVATE and zoneQuest.Completion.szQuestName == quest.szQuestName  then
				GameRules.Dungeon:OnQuestCompleted( self, zoneQuest )
			end
		end
	end

	for _, vip in pairs( self.VIPsAlive ) do
		local Dialog = GameRules.Dungeon:GetDialog( vip )
		if Dialog ~= nil and Dialog.szAdvanceQuestActive == quest.szQuestName then
			--print( "Dialog.szAdvanceQuestActive == " .. Dialog.szAdvanceQuestActive )
			vip.nCurrentLine = vip.nCurrentLine + 1
			vip:AddNewModifier( vip, nil, "modifier_npc_dialog_notify", {} )
		end
	end

	if self.Type == ZONE_TYPE_SURVIVAL then
		if self.Survival.StartQuest ~= nil and self.Survival.StartQuest.bOnCompleted == false then
			if quest.szQuestName == self.Survival.StartQuest.szQuestName then
			--	print( "CDungeonZone:OnQuestStarted() - Survival in " .. self.szName .. " starting because quest " .. quest.szQuestName .. " started." )
				self:SurvivalStart()
				return
			end
		end
	end

	if self.Type == ZONE_TYPE_HOLDOUT then
		if self.Holdout.StartQuest ~= nil and self.Holdout.StartQuest.bOnCompleted == false then
			if quest.szQuestName == self.Holdout.StartQuest.szQuestName then
			--	print( "CDungeonZone:OnQuestStarted() - Holdout in " .. self.szName .. " starting because quest " .. quest.szQuestName .. " started." )
				self:HoldoutStart()
				return
			end
		end
	end

	if self.Type == ZONE_TYPE_ASSAULT then
		if self.Assault.StartQuest ~= nil and self.Assault.StartQuest.bOnCompleted == false then
			if quest.szQuestName == self.Assault.StartQuest.szQuestName then
			--	print( "CDungeonZone:OnQuestStarted() - Assault in " .. self.szName .. " starting because quest " .. quest.szQuestName .. " started." )
				self:AssaultStart()
				return
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:OnQuestCompleted( quest )
	for _,zoneQuest in pairs ( self.Quests ) do
		if zoneQuest ~= nil and not zoneQuest.bCompleted == true then
			if zoneQuest.bActivated == false then
				local bShouldActivate = false
				for _,activator in pairs( zoneQuest.Activators ) do
					if activator ~= nil and activator.Type == QUEST_EVENT_ON_QUEST_COMPLETE and activator.szQuestName == quest.szQuestName then
						bShouldActivate = true
					end
				end

				if bShouldActivate == true then
					GameRules.Dungeon:OnQuestStarted( self, zoneQuest )
				end
			end

			if zoneQuest.bActivated == true and zoneQuest.Completion.Type == QUEST_EVENT_ON_QUEST_COMPLETE and zoneQuest.Completion.szQuestName == quest.szQuestName then
				GameRules.Dungeon:OnQuestCompleted( self, zoneQuest )
			end
		end
	end

	if self.Type == ZONE_TYPE_SURVIVAL then
		if self.Survival.StartQuest ~= nil and self.Survival.StartQuest.bOnCompleted == true then
			if quest.szQuestName == self.Survival.StartQuest.szQuestName then
			--	print( "CDungeonZone:OnQuestStarted() - Survival in " .. self.szName .. " starting because quest " .. quest.szQuestName .. " was completed." )
				self:SurvivalStart()
			end
		end
	end

	if self.Type == ZONE_TYPE_HOLDOUT then
		if self.Holdout.StartQuest ~= nil and self.Holdout.StartQuest.bOnCompleted == true then
			if quest.szQuestName == self.Holdout.StartQuest.szQuestName then
			--	print( "CDungeonZone:OnQuestStarted() - Holdout in " .. self.szName .. " starting because quest " .. quest.szQuestName .. " was completed." )
				self:HoldoutStart()
			end
		end
	end

	if self.Type == ZONE_TYPE_ASSAULT then
		if self.Assault.StartQuest ~= nil and self.Assault.StartQuest.bOnCompleted == false then
			if quest.szQuestName == self.Assault.StartQuest.szQuestName then
			--	print( "CDungeonZone:OnQuestStarted() - Assault in " .. self.szName .. " starting because quest " .. quest.szQuestName .. " started." )
				self:AssaultStart()
				return
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:Deactivate()
	if self.bActivated == false then
		return
	end

	if self.Type == ZONE_TYPE_HOLDOUT and self.Holdout.bStarted == true and self.bZoneCompleted == false then
		return
	end

	if self.Type == ZONE_TYPE_ASSAULT and self.Assault.bStarted == true and self.bZoneCompleted == false then
		return
	end

	--print( "CDungeonZone:Deactivate() - Zone " .. self.szName .. " is being deactivated." )

	self.bActivated = false

	CustomGameEventManager:Send_ServerToAllClients( "remove_vips", netTable )
end

--------------------------------------------------------------------

function CDungeonZone:OnThink()
	if self.bPrecached == false then
		return
	else
		if #self.SpawnGroups >= self.nPrecacheCount then
			if self.nPrecacheCount ~= 0 then
				self:SpawnSquadCreatures( true )
			end
		end
	end

	if GameRules:IsGamePaused() then
		return
	end

	if self:HasAnyPlayers() == true then
		if self.bActivated == false then
			self:Activate()
			return
		end
	else
		if self.bActivated == true then
			self:Deactivate()
			return
		end
		if self.bZoneCompleted == true and self.bZoneCleanupComplete == false and ( GameRules:GetGameTime() > self.flZoneCleanupTime ) then
			self:PerformZoneCleanup()
			return
		end
	end

	if self.bActivated == false then
		local Heroes = HeroList:GetAllHeroes()
		for _,enemy in pairs ( self.Enemies ) do
			if enemy ~= nil and not enemy:IsNull() and enemy:IsAlive() and enemy.bAttacker == true then
				local bCanBeSeen = false
				local Heroes = HeroList:GetAllHeroes()
				for _,Hero in pairs( Heroes ) do
					if Hero:CanEntityBeSeenByMyTeam( enemy ) then
						bCanBeSeen = true
					end
				end

				if not bCanBeSeen then
					enemy:ForceKill( false )
				end
			end
		end
		return
	end

	if #self.Bosses > 0 then
		self:BossThink()
	end

	self.flCompletionTime = self.flCompletionTime + 0.5
	self.PlayerStats["CompletionTime"] = self.flCompletionTime
	self.PlayerStats["ZoneStars"] = self.nStars
	CustomNetTables:SetTableValue( "zone_scores", self.szName, self.PlayerStats )

	self:CheckForZoneComplete()
end

--------------------------------------------------------------------

function CDungeonZone:CheckForZoneComplete()
	if self:AllQuestsComplete() == false then
		if self.Type == ZONE_TYPE_SURVIVAL then
			self:SurvivalThink()
			return
		end

		if self.Type == ZONE_TYPE_HOLDOUT then
			self:HoldoutThink()
			return
		end

		if self.Type == ZONE_TYPE_ASSAULT then
			self:AssaultThink()
			return
		end
	elseif self.bZoneCompleted == false then
		--print( "CDungeonZone:CheckForZoneComplete() - Zone " .. self.szName .. " completed in " .. self.flCompletionTime .. " seconds." )
		self.bZoneCompleted = true
		
		if not self.bNoLeaderboard then
			for nPlayerID = 0,3 do
				if self.PlayerStats[nPlayerID] ~= nil then
					if self.PlayerStats[nPlayerID]["Kills"] ~= nil then self.nKills = self.nKills + self.PlayerStats[nPlayerID]["Kills"] end
					if self.PlayerStats[nPlayerID]["Items"] ~= nil then self.nItems = self.nItems + self.PlayerStats[nPlayerID]["Items"] end
					if self.PlayerStats[nPlayerID]["GoldBags"] ~= nil then self.nGoldBags = self.nGoldBags + self.PlayerStats[nPlayerID]["GoldBags"] end
					if self.PlayerStats[nPlayerID]["Potions"] ~= nil then self.nPotions = self.nPotions + self.PlayerStats[nPlayerID]["Potions"] end
					if self.PlayerStats[nPlayerID]["ReviveTime"] ~= nil then self.nReviveTime = self.nReviveTime + self.PlayerStats[nPlayerID]["ReviveTime"] end
					if self.PlayerStats[nPlayerID]["Damage"] ~= nil then self.nDamage = self.nDamage + self.PlayerStats[nPlayerID]["Damage"] end
					if self.PlayerStats[nPlayerID]["Healing"] ~= nil then self.nHealing = self.nHealing + self.PlayerStats[nPlayerID]["Healing"] end
					if self.PlayerStats[nPlayerID]["Deaths"] ~= nil then 
						self.nDeaths = self.nDeaths + self.PlayerStats[nPlayerID]["Deaths"] 
					else
						self.PlayerStats[nPlayerID]["Deaths"] = 0
					end
				end
			end
			if self.StarCriteria ~= nil then
				for _,Criteria in pairs( self.StarCriteria ) do
					if Criteria ~= nil then
						Criteria.StarScore = 0
						Criteria.Result = 0
						if Criteria.Type == ZONE_STAR_CRITERIA_TIME then
							if Criteria.Values == nil then
								print( "CDungeonZone:CheckForZoneComplete - ERROR: StarCriteria for ZONE_STAR_CRITERIA_TIME has malformed values!" )
							end
							Criteria.Result = self.flCompletionTime
							for i=1,#Criteria.Values do
								local time = Criteria.Values[i]
								if time ~= nil and time >= Criteria.Result then 
									if i > Criteria.StarScore then
										Criteria.StarScore = i							
									end
								end
							end
							print( "CDungeonZone:CheckForZoneComplete - Score for ZONE_STAR_CRITERIA_TIME is " .. Criteria.StarScore .. " with a value of " .. Criteria.Result )
						end

						if Criteria.Type == ZONE_STAR_CRITERIA_DEATHS then
							if Criteria.Values == nil then
								print( "CDungeonZone:CheckForZoneComplete - ERROR: StarCriteria for ZONE_STAR_CRITERIA_DEATHS has malformed values!" )
							end

							Criteria.Result = self.nDeaths

							for i=1,#Criteria.Values do
								local deaths = Criteria.Values[i]
								if deaths ~= nil and deaths >= Criteria.Result then 
									if i > Criteria.StarScore then
										Criteria.StarScore = i
									end
								end
							end
							print( "CDungeonZone:CheckForZoneComplete - Score for ZONE_STAR_CRITERIA_DEATHS is " .. Criteria.StarScore .. " with a value of " .. Criteria.Result )
						end

						if Criteria.Type == ZONE_STAR_CRITERIA_QUEST_COMPLETE then
							Criteria.Result = self:GetQuestCompleteCount( Criteria.szQuestName )
							if Criteria.szQuestName == nil or nCompleteCount then
								print( "CDungeonZone:CheckForZoneComplete - ERROR: StarCriteria for ZONE_STAR_CRITERIA_QUEST_COMPLETE has invalid quest name!" )
							end
							if Criteria.Values == nil then
								print( "CDungeonZone:CheckForZoneComplete - ERROR: StarCriteria for ZONE_STAR_CRITERIA_QUEST_COMPLETE has malformed values!" )
							end
							for i=1,#Criteria.Values do
								local completed = Criteria.Values[i]
								if completed ~= nil and completed <= Criteria.Result then 
									if i > Criteria.StarScore then
										Criteria.StarScore = i
									end
								end
							end
							print( "CDungeonZone:CheckForZoneComplete - Score for ZONE_STAR_CRITERIA_QUEST_COMPLETE is " .. Criteria.StarScore .. " with a value of " .. Criteria.Result )
						end
					end
				end
				self.nStars = 9999
				for _,Criteria in pairs( self.StarCriteria ) do
					if Criteria ~= nil and Criteria.StarScore ~= nil and Criteria.StarScore < self.nStars then
						self.nStars = Criteria.StarScore
					end
				end
			end

			local nData1 = bit.bor( bit.lshift( self.nKills, 16 ), bit.band(self.nDeaths, 0xFFFF ) )
			local nData2 = bit.bor( bit.lshift( self.nGoldBags, 16 ), bit.band(self.nPotions, 0xFFFF ) )
			local nData3 = bit.bor( bit.lshift( self.nItems, 16 ), bit.band(self.nReviveTime, 0xFFFF ) )
			local nData4 = bit.bor( bit.lshift( self.nDamage / 1000, 16 ), bit.band(self.nHealing / 1000, 0xFFFF ) )
			local nData5 = bit.lshift( self.PlayerStats[0]["Deaths"], 24 ) + bit.lshift( self.PlayerStats[1]["Deaths"], 16 ) + bit.lshift( self.PlayerStats[2]["Deaths"], 8 ) + self.PlayerStats[3]["Deaths"]

			GameRules:AddEventMetadataLeaderboardEntry( self.szName, math.ceil( self.flCompletionTime ), self.nStars, 3, nData1, nData2, nData3, nData4, nData5 )

			local nFurthestZone = 0
			local nTotalTime = 0
			local nTotalStars = 0
			local nMaxTotalStars = 0
			local nTotalKills = 0
			local nTotalDeaths = 0
			local nTotalItems = 0
			local nTotalGoldBags = 0
			local nTotalPotions = 0
			local nTotalDeaths = 0
			local nTotalReviveTime = 0
			local nTotalDamage = 0
			local nTotalHealing = 0
			local nTotalPlayerDeaths = {}
			for nPlayerID = 0, 3 do
				nTotalPlayerDeaths[nPlayerID] = 0
			end

			print( "CDungeonZone:Totaling scores" )

			for zone_num,zone in pairs(GameRules.Dungeon.Zones) do
				if not zone.bNoLeaderboard then
					if zone.bZoneCompleted then
						nTotalTime = nTotalTime + math.ceil( zone.flCompletionTime )
						nTotalStars = nTotalStars + zone.nStars
						if zone_num > nFurthestZone then
							nFurthestZone = zone_num
						end
						nTotalKills = nTotalKills + zone.nKills
						nTotalDeaths = nTotalDeaths + zone.nDeaths
						nTotalItems = nTotalItems + zone.nItems			
						nTotalGoldBags = nTotalGoldBags + zone.nGoldBags
						nTotalPotions = nTotalPotions + zone.nPotions
						nTotalReviveTime = nTotalReviveTime + zone.nReviveTime
						nTotalDamage = nTotalDamage + zone.nDamage
						nTotalHealing = nTotalHealing + zone.nHealing
						for nPlayerID = 0, 3 do
							nTotalPlayerDeaths[nPlayerID] = nTotalPlayerDeaths[nPlayerID] + ( zone.PlayerStats[nPlayerID]["Deaths"] or 0 )
						end
					end

					nMaxTotalStars = nMaxTotalStars + 3

					print( "CDungeonZone:Totaling - through zone " .. zone.szName .. ", stars: " .. nTotalStars )

				end
			end

			local nTotalData1 = bit.lshift( nTotalKills, 16 ) + bit.lshift( nFurthestZone - 1, 8 ) + bit.band( nTotalDeaths, 0xFF )
			local nTotalData2 = bit.lshift( nTotalGoldBags, 16 ) + bit.band( nTotalPotions, 0xFFFF )
			local nTotalData3 = bit.lshift( nTotalItems, 16 ) + bit.band( nTotalReviveTime, 0xFFFF )
			local nTotalData4 = bit.lshift( nTotalDamage / 1000000, 16 ) + bit.band( nTotalHealing / 1000000, 0xFFFF )
			local nTotalData5 = bit.lshift( nTotalPlayerDeaths[0], 24 ) + bit.lshift( nTotalPlayerDeaths[1], 16 ) + bit.lshift( nTotalPlayerDeaths[2], 8 ) + nTotalPlayerDeaths[3]

			GameRules:AddEventMetadataLeaderboardEntry( "total", nTotalTime, nTotalStars, nMaxTotalStars, nTotalData1, nTotalData2, nTotalData3, nTotalData4, nTotalData5 )
		end

		GameRules.Dungeon:OnZoneCompleted( self )

		local netTable = {}
		netTable["CompletionTime"] = self.flCompletionTime
		netTable["ZoneName"] = self.szName
		netTable["ZoneStars"] = self.nStars
		self.flZoneCleanupTime = GameRules:GetGameTime() + 180.0
		if not self.bNoLeaderboard then
			CustomGameEventManager:Send_ServerToAllClients( "zone_complete", netTable )
		end

		self.PlayerStats["CompletionTime"] = self.flCompletionTime
		self.PlayerStats["ZoneStars"] = self.nStars
		CustomNetTables:SetTableValue( "zone_scores", self.szName, self.PlayerStats )

		for _,neutral in pairs( self.NeutralsAlive ) do
			neutral:AddNewModifier( neutral, nil, "modifier_npc_dialog", {} )
		end

		if self.bVictoryOnComplete == true then
			GameRules.Dungeon.flVictoryTime = GameRules:GetGameTime() + 0.0
		end

		self:Deactivate()
	end
end

--------------------------------------------------------------------

function CDungeonZone:PerformZoneCleanup()
	if #self.Enemies > 0 then
		--print( "CDungeonZone:PerformZoneCleanup() - There are " .. #self.Enemies .. " enemies remaining in " .. self.szName )
		local Heroes = HeroList:GetAllHeroes()
		local nEnemiesRemoved = 0
		for i=#self.Enemies,1,-1 do
			local enemy = self.Enemies[i]
			if enemy ~= nil and enemy:IsNull() == false then
				local bCanBeSeen = false 
				for _,Hero in pairs( Heroes ) do
					if Hero:CanEntityBeSeenByMyTeam( enemy ) then
						bCanBeSeen = true
					end
				end
				if not bCanBeSeen then
					UTIL_Remove( enemy )
					table.remove( self.Enemies, i )
					nEnemiesRemoved = nEnemiesRemoved + 1
				end
			end
		end
	--	print( "CDungeonZone:PerformZoneCleanup() - Removed " .. nEnemiesRemoved.. " enemies from " .. self.szName  )
	else
	--	print( "CDungeonZone:PerformZoneCleanup() - Unloading " .. #self.SpawnGroups .. " spawn groups from " .. self.szName  )
		for _,SpawnGroup in pairs( self.SpawnGroups ) do
			if SpawnGroup ~= nil then
				UnloadSpawnGroupByHandle( SpawnGroup )
			end
		end
		self.bZoneCleanupComplete = true
	end
end

--------------------------------------------------------------------

function CDungeonZone:HasAnyPlayers()
	if self.hZoneTrigger == nil then
		print( "CDungeonZone:HasAnyPlayers() - ERROR: No Zone Volume" )
		return false
	end

	local Heroes = HeroList:GetAllHeroes()
	if #Heroes == 0 then
		print( "CDungeonZone:HasAnyPlayers() - ERROR: No Heroes" )
		return
	end

	for _,hero in pairs ( Heroes ) do
		if self:ContainsUnit( hero ) then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------

function CDungeonZone:ContainsUnit( hUnit )
	if self.hZoneTrigger == nil or self.bZoneCompleted == true then
		return false
	end

	return self.hZoneTrigger:IsTouching( hUnit )
end

--------------------------------------------------------------------

function CDungeonZone:OnBossStart( hBoss )
	if hBoss == nil then
		print ( "CDungeonZone:OnBossStart - ERROR: Boss Start with invalid boss" )
		return
	end

	if hBoss.bStarted == true then
		print ( "CDungeonZone:OnBossStart - ERROR: Boss already started" )
		return
	end

	GameRules.Dungeon:OnBossFightIntro( hBoss )
end

--------------------------------------------------------------------

function CDungeonZone:BossThink()
	--print( "CDungeonZone:BossThink()" )
	local Heroes = HeroList:GetAllHeroes()
	local nBossesIntroComplete = 0
	local nTotalBossHPPct = 0
	for _,Boss in pairs ( self.Bosses ) do
		if Boss.bAwake == nil or Boss.bAwake == true then
			--print( "CDungeonZone:BossThink() - Boss is awake" )
			if Boss.bStarted == false then
			--print( "CDungeonZone:BossThink() - Boss has not started" )
				for _,Hero in pairs ( Heroes ) do
					if Hero ~= nil and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and Hero:CanEntityBeSeenByMyTeam( Boss ) then
					--	print( "CDungeonZone:BossThink() - Starting Boss" )
						self:OnBossStart( Boss )
						return
					end
				end
			else
				--print( "CDungeonZone:BossThink() - Boss has started" )
				if Boss.bStarted == true and GameRules:GetGameTime() > Boss.flIntroEndTime and Boss.bIntroComplete == false then
					Boss.bIntroComplete = true
					GameRules.Dungeon:OnBossFightIntroEnd( Boss )
					return
				end
			end
			
			if Boss.bIntroComplete == true then
				nBossesIntroComplete = nBossesIntroComplete + 1
				if Boss:IsAlive() then
					local bCanBeSeen = false
					for _,Hero in pairs( Heroes ) do
						if Hero:CanEntityBeSeenByMyTeam( Boss ) and Hero:IsAlive() then
							bCanBeSeen = true
							if Boss:FindModifierByName( "modifier_provide_vision" ) == nil then
								Boss:AddNewModifier( Hero, nil, "modifier_provide_vision", {} )
							end
						end
					end
					if bCanBeSeen then
						nTotalBossHPPct = nTotalBossHPPct + Boss:GetHealthPercent()
					else
						Boss:RemoveModifierByName( "modifier_provide_vision" )
					end
				end	
			end
		end	
	end

	if self:GetNumberOfBosses() == nBossesIntroComplete and nBossesIntroComplete ~= 0 then
		local netTable = {}
		netTable["boss_hp"] = nTotalBossHPPct / ( 100 * self:GetNumberOfBosses() ) * 100
		CustomNetTables:SetTableValue( "boss", string.format( "%d", 0 ), netTable )
	end
end

--------------------------------------------------------------------

function CDungeonZone:SurvivalStart()
	--print( "CDungeonZone:SurvivalStart()" )

	self.Survival.bStarted = true

	if not self.Survival.flSpawnInterval then
		self.Survival.flSpawnInterval = self.Survival.flMaxSpawnInterval or 60.0
		if self.Survival.flMaxSpawnInterval == nil then
			self.Survival.flMaxSpawnInterval = 60.0
			print( "CDungeonZone:SurvivalStart - WARNING: No flMaxSpawnInterval defined.  Using default of " .. self.Survival.flMaxSpawnInterval .. " instead." )
		end
		if self.Survival.flMinSpawnInterval == nil then
			self.Survival.flMinSpawnInterval = 30.0
			print( "CDungeonZone:SurvivalStart - WARNING: No flMinSpawnInterval defined.  Using default of " .. self.Survival.flMinSpawnInterval .. " instead." )
		end
		if self.Survival.flSpawnIntervalChange == nil then
			self.Survival.flSpawnIntervalChange = 5.0
			print( "CDungeonZone:SurvivalStart - WARNING: No flSpawnIntervalChange defined.  Using default of " .. self.Survival.flSpawnIntervalChange .. " instead." )
		end
	end

	--print( "CDungeonZone:SurvivalStart() - " .. ConvertToTime( GameRules:GetGameTime() ) .. " - Spawning creeps in " .. self.Survival.flSpawnInterval .. " seconds." )
	self.Survival.flTimeOfNextAttack = GameRules:GetGameTime() + self.Survival.flSpawnInterval
end

--------------------------------------------------------------------

function CDungeonZone:SurvivalThink()
	if self.Survival.bStarted == false then
		return
	end

	local flTimeNow = GameRules:GetGameTime()
	if flTimeNow > self.Survival.flTimeOfNextAttack then
		self:SpawnSurvivalAttackers()
		local flNewInterval = math.max( self.Survival.flMinSpawnInterval, self.Survival.flSpawnInterval - self.Survival.flSpawnIntervalChange )
		--print( "CDungeonZone:SurvivalThink() - " .. ConvertToTime( flTimeNow ) .. " - Previous interval: " .. self.Survival.flSpawnInterval .. ", new interval:" .. flNewInterval )
		self.Survival.flSpawnInterval = flNewInterval
		--print( "CDungeonZone:SurvivalThink() - " .. ConvertToTime( flTimeNow ) .. " - Spawning creeps in " .. self.Survival.flSpawnInterval .. " seconds." )
		self.Survival.flTimeOfNextAttack = flTimeNow + self.Survival.flSpawnInterval
	end
end

--------------------------------------------------------------------

function CDungeonZone:SpawnSurvivalAttackers()
	--print( "-----------------------------------" )
	--print( "CDungeonZone:SpawnSurvivalAttackers()" )

	self:SpawnChasingSquads( self.Survival.nSquadsPerSpawn, DOTA_TEAM_BADGUYS, self.Survival.ChasingSquads, self.Survival.ChasingSpawners, self.Squads, self.Survival.bDontRepeatSquads )
end

--------------------------------------------------------------------

function CDungeonZone:HoldoutStart()
	--print( "CDungeonZone:HoldoutStart()" )
	if self.bActivated == false then
		self:Activate()
	end
	self.Holdout.bStarted = true
	self.Holdout.nLastReportedCount = 0
	self.flTimeOfNextWave = GameRules:GetGameTime()

	local netTable = {}
	for index,VIP in pairs( self.VIPsAlive ) do
		netTable[index] = VIP:entindex()
		VIP:RemoveModifierByName( "modifier_stack_count_animation_controller" )
	end
	for _,neutral in pairs( self.NeutralsAlive ) do
		if neutral ~= nil and neutral:IsNull() == false and neutral:FindAbilityByName( "ability_journal_note" ) == nil then
			neutral:RemoveModifierByName( "modifier_stack_count_animation_controller" )
			neutral:RemoveModifierByName( "modifier_npc_dialog" )
		end	
	end
	CustomNetTables:SetTableValue( "vips", string.format( "%d", 0 ), netTable )
end

--------------------------------------------------------------------

function CDungeonZone:HoldoutThink()
	if self.Holdout.bCompleted == true or self.Holdout.bStarted == false then
		return
	end

	for index, VIP in pairs ( self.VIPsAlive ) do
		if VIP:IsNull() or VIP:IsAlive() == false then
			--print( "vip died" )
			self.nVIPsKilled = self.nVIPsKilled + 1
			table.remove( self.VIPsAlive, index )

			if self.nVIPsKilled > self.nVIPDeathsAllowed then
				GameRules.Dungeon:OnGameFinished()
				GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
			end
		end
	end

	for index2, neutral in pairs ( self.NeutralsAlive ) do
		if neutral:IsNull() or neutral:IsAlive() == false then
			--print( "vip died" )
			table.remove(self.NeutralsAlive, index2 )
		end
	end

	local nTotalEnemiesRemaining = #self.Enemies
	local nEnemiesRemainingToSpawn = 0
	if self.nCurrentWave > 0 then
		local NPCs = self.Waves[self.nCurrentWave].NPCs
		if NPCs ~= nil then
			for _,npc in pairs( NPCs ) do
				if npc.flDelay ~= nil then
					nEnemiesRemainingToSpawn = nEnemiesRemainingToSpawn + 1
				end
			end
		end
	end

	nTotalEnemiesRemaining = nTotalEnemiesRemaining + nEnemiesRemainingToSpawn
	if self.Holdout.nLastReportedCount ~= nTotalEnemiesRemaining then
	--	print( "CDungeonZone:HoldoutThink() - There are " .. nTotalEnemiesRemaining .. " enemies remaining in holdout event." )
		self.Holdout.nLastReportedCount = nTotalEnemiesRemaining
	end
	if nEnemiesRemainingToSpawn > 0 then 
	--	print( "CDungeonZone:HoldoutThink() - There are " .. nEnemiesRemainingToSpawn .. " enemies delayed in holdout event." )
	end	

	local flTimeNow = GameRules:GetGameTime()
	if flTimeNow > self.flTimeOfNextWave and self.nCurrentWave < #self.Waves then
		self.nCurrentWave = self.nCurrentWave + 1
	--	print( "CDungeonZone:HoldoutThink() - Wave Start - " .. self.nCurrentWave )
		self:SpawnPathingSquads( self.Waves[self.nCurrentWave], DOTA_TEAM_BADGUYS )

		self.flTimeOfNextSpawn = flTimeNow + self.Waves[self.nCurrentWave].flSpawnInterval
		self.flTimeOfNextWave = flTimeNow + self.Waves[self.nCurrentWave].flDuration
	--	print( "CDungeonZone:HoldoutThink() - Next Wave at " .. ConvertToTime( self.flTimeOfNextWave ) )
	--	print( "CDungeonZone:HoldoutThink() - Next Spawn at " .. ConvertToTime( self.flTimeOfNextSpawn ) )
	else
		if self.nCurrentWave == 0 then
			return
		end

		if flTimeNow > self.flTimeOfNextSpawn then
			self:SpawnPathingSquads( self.Waves[self.nCurrentWave], DOTA_TEAM_BADGUYS )
			self.flTimeOfNextSpawn = flTimeNow + self.Waves[self.nCurrentWave].flSpawnInterval
	--		print( "CDungeonZone:HoldoutThink() - Next Spawn at " .. ConvertToTime( self.flTimeOfNextSpawn ) )
		end
	end

	if self.nCurrentWave == #self.Waves then
	--	print( "CDungeonZone:HoldoutThink() - All Waves Completed" )	
		if nTotalEnemiesRemaining == 0 then
	--		print( "CDungeonZone:HoldoutThink() - Holdout Event Completed" )	
			self.Holdout.bCompleted = true
			GameRules.Dungeon:OnZoneEventComplete( self )
		else
	--		print( "CDungeonZone:HoldoutThink() - Holdout Event has " .. nEnemiesRemainingToSpawn .. " enemies waiting to spawn." )	
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:AssaultStart()
	--print( "CDungeonZone:AssaultStart()" )
	if self.bActivated == false then
		self:Activate()
	end
	self.Assault.bStarted = true
	for _,Attacker in pairs( self.Assault.Attackers ) do
		if Attacker ~= nil then
			Attacker.flTimeOfNextSpawn = GameRules:GetGameTime()
		end
	end
	self.Assault.RescuedAttackers = {}
	local hRescuedAttackerEntity = Entities:FindByName( nil, self.Assault.szRescuedAttackerStartEntity )
	if hRescuedAttackerEntity ~= nil then
		local hRescuedEntities = FindUnitsInRadius( self.Assault.nAttackerTeam, hRescuedAttackerEntity:GetAbsOrigin(), hRescuedAttackerEntity, 2500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,RescuedEntity in pairs ( hRescuedEntities ) do
			for _,szRescuedName in pairs ( self.Assault.szRescuedAttackerTypes ) do
				if RescuedEntity:GetUnitName() == szRescuedName then			
		--			print( "CDungeonZone:AssaultStart() - Adding " .. szRescuedName .. " to Assault attackers." )
					if RescuedEntity:GetUnitName() == "npc_dota_creature_friendly_ogre_tank" or RescuedEntity:GetUnitName() == "npc_dota_radiant_captain" then
						local hWaypoint = Entities:FindByName( nil, self.Assault.szRescuedAttackerWaypoint )
						if hWaypoint == nil then
							print( "CDungeonZone:AssaultThink() - ERROR: Rescued waypoint is nil." )
						end

		--				print( "CDungeonZone:AssaultThink() - Issuing order to " .. RescuedEntity:GetUnitName() )
						RescuedEntity:SetInitialGoalEntity( hWaypoint )
						RescuedEntity:RemoveModifierByName( "modifier_npc_dialog" )
						RescuedEntity:RemoveModifierByName( "modifier_npc_dialog_notify" )
						RescuedEntity:RemoveModifierByName( "modifier_stack_count_animation_controller" )
					else
						table.insert( self.Assault.RescuedAttackers, RescuedEntity )
					end
				end
			end

		end
	end

	self.Assault.Defenders.flTimeOfNextSpawn = GameRules:GetGameTime()
end

--------------------------------------------------------------------

function CDungeonZone:AssaultThink()
	if self.Assault.bCompleted == true or self.Assault.bStarted == false then
		return
	end

	local flTimeNow = GameRules:GetGameTime()
	for _,Attacker in pairs( self.Assault.Attackers ) do
		if Attacker ~= nil then
			if flTimeNow >= Attacker.flTimeOfNextSpawn then
				self:SpawnPathingSquads( Attacker, self.Assault.nAttackerTeam )
				Attacker.flTimeOfNextSpawn = flTimeNow + Attacker.flSpawnInterval
				local nOrdersLeft = self.Assault.nMaxRescuedAttackersPerWave 
				while #self.Assault.RescuedAttackers > 0 and nOrdersLeft > 0 do
					local nIndex = RandomInt( 1, #self.Assault.RescuedAttackers )
					local hRescuedAttacker = self.Assault.RescuedAttackers[nIndex]
					local hWaypoint = Entities:FindByName( nil, self.Assault.szRescuedAttackerWaypoint )
					if hRescuedAttacker == nil or hRescuedAttacker:IsNull() then
						print( "CDungeonZone:AssaultThink() - ERROR: Rescued Attacker is nil." )
					end
					if hWaypoint == nil then
						print( "CDungeonZone:AssaultThink() - ERROR: Rescued waypoint is nil." )
					end

		--			print( "CDungeonZone:AssaultThink() - Issuing order to " .. hRescuedAttacker:GetUnitName() )
					hRescuedAttacker:SetInitialGoalEntity( hWaypoint )
					hRescuedAttacker:RemoveModifierByName( "modifier_npc_dialog" )
					hRescuedAttacker:RemoveModifierByName( "modifier_npc_dialog_notify" )
					hRescuedAttacker:RemoveModifierByName( "modifier_stack_count_animation_controller" )
					
					nOrdersLeft = nOrdersLeft - 1
					table.remove( self.Assault.RescuedAttackers, nIndex )
				end
			end	
		end
	end

	if flTimeNow >= self.Assault.Defenders.flTimeOfNextSpawn then
		if #self.Enemies >= self.Assault.nMaxDefenders then
		--	print ( "CDungeonZone:AssaultThink - Number of defenders: " .. #self.Enemies .. " exceeds max defender count of: " .. self.Assault.nMaxDefenders )
		else 
			self:SpawnChasingSquads( self.Assault.Defenders.nSquadsPerSpawn, self.Assault.nDefenderTeam, self.Assault.Defenders.ChasingSquads, self.Assault.Defenders.ChasingSpawners, self.Squads, self.Assault.Defenders.bDontRepeatSquads )
		end
		self.Assault.Defenders.flTimeOfNextSpawn = flTimeNow + self.Assault.Defenders.flSpawnInterval
	end
end

--------------------------------------------------------------------

function CDungeonZone:AddEnemyToZone( hUnit )
	table.insert( self.Enemies, hUnit )
	if hUnit.bBoss == true then
		table.insert( self.Bosses, hUnit )
	end
	hUnit.zone = self
	hUnit.nMinGoldBounty = hUnit:GetMinimumGoldBounty()
	hUnit.nMaxGoldBounty = hUnit:GetMaximumGoldBounty()
	hUnit.nDeathXP = hUnit:GetDeathXP()
	hUnit:SetMinimumGoldBounty( 0 )
	hUnit:SetMaximumGoldBounty( 0 )
	hUnit:SetDeathXP( 0 )
	if self.bDropsDisabled and hUnit.bBoss ~= true then
		hUnit:RemoveAllItemDrops()
	end
end

--------------------------------------------------------------------

function CDungeonZone:AddTreasureChestToZone( hUnit )
	--table.insert( self.ChestUnits, hUnit )
	hUnit.zone = self
end

--------------------------------------------------------------------


function CDungeonZone:AddBreakableContainerToZone( hUnit )
	--table.insert( self.BreakableContainerUnits, hUnit )
	hUnit.zone = self
end

--------------------------------------------------------------------

function CDungeonZone:CleanupZoneEnemy( deadEnemy )
	local bIsBoss = deadEnemy.bBoss

	for i=1,#self.Enemies do 
		local enemy = self.Enemies[i]
		if enemy == deadEnemy then
			table.remove( self.Enemies, i )
		end
	end

	if bIsBoss == true then
		for i=1,#self.Bosses do 
			local enemy = self.Bosses[i]
			if enemy == deadEnemy then
				table.remove( self.Bosses, i )
				if #self.Bosses == 0 then
					local netTable = {}
					netTable["boss_hp"] = 0
					CustomNetTables:SetTableValue( "boss", string.format( "%d", 0 ), netTable )
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:GetNumberOfEnemies()
	return #self.Enemies
end

--------------------------------------------------------------------

function CDungeonZone:GetNumberOfBosses()
	return #self.Bosses
end

--------------------------------------------------------------------

function CDungeonZone:WakeBosses()
	for _,Boss in pairs( self.Bosses ) do
		Boss.bAwake = true
	end
end

--------------------------------------------------------------------

function CDungeonZone:InBossFight()
	for _,Boss in pairs( self.Bosses ) do
		if Boss.bStarted == true and Boss:IsAlive() then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------

function CDungeonZone:AllQuestsComplete()
	for _,quest in pairs ( self.Quests ) do
		if quest ~= nil and quest.bCompleted == false and quest.bOptional == false then
			return false
		end
	end

	return true
end

--------------------------------------------------------------------

function CDungeonZone:RemoveItemDropsFromZoneEnemies()
	if self.bDropsDisabled == true then
		return
	end

	for _,enemy in pairs ( self.Enemies ) do
		if enemy ~= nil and enemy.bBoss == false then
			enemy:RemoveAllItemDrops()
		end
	end

	self.bDropsDisabled = true
	--print( "CDungeonZone:RemoveItemDropsFromZoneEnemies()" )
end

--------------------------------------------------------------------

function CDungeonZone:AddStat( nPlayerID, Type, flAmount )
	if PlayerResource:IsValidTeamPlayer( nPlayerID ) then
		if self.PlayerStats[nPlayerID] == nil then
			self.PlayerStats[nPlayerID] = {}
		end
		if Type == ZONE_STAT_KILLS then
			if self.PlayerStats[nPlayerID]["Kills"] == nil then
				self.PlayerStats[nPlayerID]["Kills"] = 0
			end
			self.PlayerStats[nPlayerID]["Kills"] = self.PlayerStats[nPlayerID]["Kills"] + flAmount
		end
		if Type == ZONE_STAT_DEATHS then
			if self.PlayerStats[nPlayerID]["Deaths"] == nil then
				self.PlayerStats[nPlayerID]["Deaths"] = 0
			end
			self.PlayerStats[nPlayerID]["Deaths"] = self.PlayerStats[nPlayerID]["Deaths"] + flAmount
		end
		if Type == ZONE_STAT_ITEMS then
			if self.PlayerStats[nPlayerID]["Items"] == nil then
				self.PlayerStats[nPlayerID]["Items"] = 0
			end
			self.PlayerStats[nPlayerID]["Items"] = self.PlayerStats[nPlayerID]["Items"] + flAmount
		end
		if Type == ZONE_STAT_GOLD_BAGS then
			if self.PlayerStats[nPlayerID]["GoldBags"] == nil then
				self.PlayerStats[nPlayerID]["GoldBags"] = 0
			end
			self.PlayerStats[nPlayerID]["GoldBags"] = self.PlayerStats[nPlayerID]["GoldBags"] + flAmount
		end
		if Type == ZONE_STAT_POTIONS then
			if self.PlayerStats[nPlayerID]["Potions"] == nil then
				self.PlayerStats[nPlayerID]["Potions"] = 0
			end
			self.PlayerStats[nPlayerID]["Potions"] = self.PlayerStats[nPlayerID]["Potions"] + flAmount
		end
		if Type == ZONE_STAT_REVIVE_TIME then
			if self.PlayerStats[nPlayerID]["ReviveTime"] == nil then
				self.PlayerStats[nPlayerID]["ReviveTime"] = 0
			end
			self.PlayerStats[nPlayerID]["ReviveTime"] = self.PlayerStats[nPlayerID]["ReviveTime"] + flAmount
		end
		if Type == ZONE_STAT_DAMAGE then
			if self.PlayerStats[nPlayerID]["Damage"] == nil then
				self.PlayerStats[nPlayerID]["Damage"] = 0
			end
			self.PlayerStats[nPlayerID]["Damage"] = self.PlayerStats[nPlayerID]["Damage"] + flAmount
		end
		if Type == ZONE_STAT_HEALING then
			if self.PlayerStats[nPlayerID]["Healing"] == nil then
				self.PlayerStats[nPlayerID]["Healing"] = 0
			end
			self.PlayerStats[nPlayerID]["Healing"] = self.PlayerStats[nPlayerID]["Healing"] + flAmount
		end

		if self.szName ~= "start" then
			CustomNetTables:SetTableValue( "zone_scores", self.szName, self.PlayerStats )
		end
	end
end

--------------------------------------------------------------------

function CDungeonZone:GetCheckpoint()
	return self.hZoneCheckpoint
end

--------------------------------------------------------------------

function CDungeonZone:SetCheckpoint( hCheckpoint )
	--print( "CDungeonZone:SetCheckpoint - Assigning new checkpoint for zone " .. self.szName )
	self.hZoneCheckpoint = hCheckpoint 
end

--------------------------------------------------------------------

function CDungeonZone:IsCheckpointActivated()
	if self.hZoneCheckpoint == nil then
		print( "Zone checkpoint is nil in " .. self.szName )
		return false
	end

	if self.hZoneCheckpoint:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then
		print( "Zone checkpoint not yet tagged in  " .. self.szName )
		return false
	end

	return true
end
