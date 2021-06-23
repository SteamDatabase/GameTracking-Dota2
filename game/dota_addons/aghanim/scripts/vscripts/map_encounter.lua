require( "constants" )
require( "ascension_levels" )
require( "map_room" )
require( "utility_functions" )
require( "spawner" )
require( "portalspawner" )
require( "portalspawnerv2" )


LinkLuaModifier( "modifier_monster_leash", "modifiers/modifier_monster_leash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_passive_autocast", "modifiers/modifier_passive_autocast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_cast_warning", "modifiers/modifier_ability_cast_warning", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_plasma_field_display", "modifiers/modifier_ascension_plasma_field_display", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter == nil then
	CMapEncounter = class({})
end

--------------------------------------------------------------------------------

function CMapEncounter:constructor( hRoom, szEncounterName )	
	self.szEncounterName = szEncounterName
	self.hRoom = hRoom

	if self.hRoom == nil then
		print( "ERROR - Nil room for " .. szEncounterName )
		return
	end

	self.Spawners = {}
	self.PortalSpawners = {}
	self.RetreatPoints = {}
	self.PortalSpawnersV2 = {}

	self.flStartTime = -1
	self.EventListeners = {}
	self.bCompleted = false
	self.flCompletionTime = nil
	self.bDevForceCompleted = false
	self.bHasGeneratedRewards = false
	self.bHasSpawnedEndLevelEntities = false
	self.vRoomRewardCratePos = self.hRoom:GetOrigin()
	self.szPortalTriggerSpawner = nil
	self.flPortalTriggerDelay = 0

	self.nMaxSpawnedUnitCount = 0
	self.nUnitsRemainingForRewardDrops = 0

	self.SpawnedEnemies = {}
	self.SpawnedSecondaryEnemies = {}
	self.SpawnedPortalTriggerUnits = {}
	self.nKilledEnemies = 0
	self.nKilledSecondaryEnemies = 0

	self.SpawnedBreakables = {}
	self.SpawnedExplosiveBarrels = {}

	self.bCalculateRewardsFromUnitCount = false
	self.hTreasureRandomStream = nil
	self.hTreasureList = {}

	local nTotalGoldReward = self:GetTotalGoldRewardPerPlayer()
	self.nGoldReward = nTotalGoldReward
	self.nTotalGoldFromEnemies = nTotalGoldReward - self.nGoldReward
	self.nRemainingGoldFromEnemies = self.nTotalGoldFromEnemies

	local nTotalXPReward = self:GetTotalXPRewardPerPlayer()
	self.nXPReward = nTotalXPReward / 2
	self.nTotalXPFromEnemies = nTotalXPReward - self.nXPReward
	self.nRemainingXPFromEnemies = self.nTotalXPFromEnemies

	self.nNumItemsToDrop = 0
	self.nNumBPToDrop = 0
	self.nNumFragmentsToDrop = 0

	self.nChestsToSpawn = 0
	if self.hRoom:GetType() == ROOM_TYPE_TRAPS then
		self.nChestsToSpawn = self:RoomRandomInt( DEFAULT_MIN_CHESTS, DEFAULT_MAX_CHESTS )
	--elseif self.hRoom:GetType() == ROOM_TYPE_STARTING then
		--self.nChestsToSpawn = 8 -- dev test
	end

	self.nCratesToSpawn = 0
	if self.hRoom:GetType() == ROOM_TYPE_ENEMY then
		self.nCratesToSpawn = self:RoomRandomInt( DEFAULT_MIN_CRATES_ENEMY_ENC, DEFAULT_MAX_CRATES_ENEMY_ENC )
	elseif self.hRoom:GetType() == ROOM_TYPE_BOSS then
		self.nCratesToSpawn = self:RoomRandomInt( DEFAULT_MIN_CRATES_BOSS_ENC, DEFAULT_MAX_CRATES_BOSS_ENC )
	end

	self.nExplosiveBarrelsToSpawn = 0
	local bSpawnExplosiveBarrels = self:RoomRollPercentage( ENCOUNTER_SPAWN_BARRELS_CHANCE )
	if bSpawnExplosiveBarrels then
		if self.hRoom:GetType() == ROOM_TYPE_ENEMY then
			self.nExplosiveBarrelsToSpawn = self:RoomRandomInt( DEFAULT_MIN_BARRELS_ENEMY_ENC, DEFAULT_MAX_BARRELS_ENEMY_ENC )
		end
	end

	self.nObjectiveNumber = 1

	self.ClientData = {}
	self.ClientData[ "encounter_name" ] = szEncounterName
	self.ClientData[ "encounter_depth" ] = self.hRoom:GetDepth()
	self.ClientData[ "room_type" ] = GetStringForRoomType( self.hRoom:GetType() )
	self.ClientData[ "objectives" ] = {}
end

--------------------------------------------------------------------------------

function CMapEncounter:RoomRandomInt( nMinInt, nMaxInt )
	return self:GetRoom():RoomRandomInt( nMinInt, nMaxInt )
end

--------------------------------------------------------------------------------

function CMapEncounter:RoomRandomFloat( flMin, flMin )
	return self:GetRoom():RoomRandomFloat( flMin, flMin )
end

---------------------------------------------------------------------------

function CMapEncounter:RoomRollPercentage( nChance )
	local bOutcome = self:RoomRandomInt( 1, 100 ) <= nChance
	return bOutcome
end

---------------------------------------------------------------------------

function CMapEncounter:GetTreasureRandomStream( )
	if self.hTreasureRandomStream == nil then
		self.hTreasureRandomStream = CreateUniformRandomStream( GameRules.Aghanim:GetRandomSeed() + MakeStringToken( self:GetRoom():GetName() ) )
	end
	return self.hTreasureRandomStream
end

---------------------------------------------------------------------------

function CMapEncounter:RegisterTreasureItem( hTreasureItem )
	table.insert( self.hTreasureList, hTreasureItem )
end

--------------------------------------------------------------------------------

function CMapEncounter:OnEliteRankChanged( nEliteDepthBonus )

	if nEliteDepthBonus > 0 then
		self.ClientData[ "hard_room" ] = 1
	else
		self.ClientData[ "hard_room" ] = 0
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:SelectAscensionAbilities( )
	self.AscensionAbilities = {}
	self.hDummyAscensionCaster = nil
	self.ClientData[ "ascension_abilities" ] = {}
	self.ClientData[ "total_difficulty" ] = 0

	if self:GetRoom():GetType() ~= ROOM_TYPE_ENEMY then
		if self:GetRoom():GetType() == ROOM_TYPE_BOSS then
			if GameRules.Aghanim.bIsInTournamentMode and #TRIALS_BOSS_ASCENSION_ABILITIES > 0 then
				for i=1,#TRIALS_BOSS_ASCENSION_ABILITIES do
					print( "Encounter " .. self.szEncounterName .. " added trial ascension ability " .. TRIALS_BOSS_ASCENSION_ABILITIES[i] )
					table.insert( self.AscensionAbilities, TRIALS_BOSS_ASCENSION_ABILITIES[i] )
					self.ClientData[ "ascension_abilities" ][ tostring(i) ] = TRIALS_BOSS_ASCENSION_ABILITIES[i]
				end
			else

				if GameRules.Aghanim:GetAscensionLevel() == AGHANIM_ASCENSION_APEX_MAGE then
					local nIndex = self:RoomRandomInt( 1, #APEX_BOSS_ASCENSION_ABILITIES )
					print( "Encounter " .. self.szEncounterName .. " added boss ascension ability " .. APEX_BOSS_ASCENSION_ABILITIES[ nIndex ] )
					table.insert( self.AscensionAbilities, APEX_BOSS_ASCENSION_ABILITIES[ nIndex ] )
					self.ClientData[ "ascension_abilities" ][ 1 ] = APEX_BOSS_ASCENSION_ABILITIES[ nIndex ]
				end
			end
		end
		return
	end

	local nEliteLevel = self:GetRoom():GetEliteRank()
	local nAscensionLevel = nEliteLevel + GameRules.Aghanim:GetAscensionLevel()
	self.ClientData[ "total_difficulty" ] = nAscensionLevel

	local nDesiredAbilityCount = EXTRA_ABILITIES_PER_ASCENSION_LEVEL[ nAscensionLevel + 1 ]
	if nDesiredAbilityCount == 0 then
		return
	end

	local vecAbilityOptions = {}
	local vecEliteAbilityOptions = {}

	if GameRules.Aghanim.bIsInTournamentMode and #TRIALS_ASCENSION_ABILITIES > 0 then
		print( "Using trials forced ascension abilities" )
		for _,szTrialAbilityName in pairs( TRIALS_ASCENSION_ABILITIES ) do
			for abilityName,hPossibleAbility in pairs( ASCENSION_ABILITIES ) do
				if abilityName == szTrialAbilityName then
					if hPossibleAbility.bEliteOnly == true then
						table.insert( vecEliteAbilityOptions, abilityName )
					else
						table.insert( vecAbilityOptions, abilityName )
					end
				end	
			end
		end
	else
		for abilityName,hPossibleAbility in pairs( ASCENSION_ABILITIES ) do
			if hPossibleAbility.vecBlacklistedEncounters ~= nil then
				for i=1,#hPossibleAbility.vecBlacklistedEncounters do
					local szBlacklisted = hPossibleAbility.vecBlacklistedEncounters[i]
					if szBlacklisted == self.szEncounterName then
						--print( "Encounter " .. self.szEncounterName .. " blacklisted " .. abilityName )
						goto continue
					end
				end
			end

			if hPossibleAbility.nRestrictToAct ~= nil then 
				if hPossibleAbility.nRestrictToAct ~= self:GetRoom():GetAct() then
					goto continue
				end

				if hPossibleAbility.szRequiredBoss ~= nil and hPossibleAbility.szRequiredBoss ~= GameRules.Aghanim:GetBossUnitForAct( hPossibleAbility.nRestrictToAct ) then
					goto continue
				end
			end

			if hPossibleAbility.nMinAscensionLevel ~= nil and hPossibleAbility.nMinAscensionLevel > nAscensionLevel then
				goto continue
			end

			if hPossibleAbility.nMaxAscensionLevel ~= nil and hPossibleAbility.nMaxAscensionLevel < nAscensionLevel then
				goto continue
			end

			if hPossibleAbility.bEliteOnly == true then
				table.insert( vecEliteAbilityOptions, abilityName )
			else
				table.insert( vecAbilityOptions, abilityName )
			end
			::continue::
		end
	end

	

	-- Force specific abilities
	local nStart = 1
	if ASCENSION_ABILITIES_FORCE_LIST ~= nil then
		for i=1,#ASCENSION_ABILITIES_FORCE_LIST do
			--print( "Encounter " .. self.szEncounterName .. " added ascension ability " .. ASCENSION_ABILITIES_FORCE_LIST[i] )
			table.insert( self.AscensionAbilities, ASCENSION_ABILITIES_FORCE_LIST[i] )
			self.ClientData[ "ascension_abilities" ][ tostring(i) ] = ASCENSION_ABILITIES_FORCE_LIST[i]
			for j=1,#vecAbilityOptions do
				if vecAbilityOptions[j] == ASCENSION_ABILITIES_FORCE_LIST[i] then
					table.remove( vecAbilityOptions, j )
					break
				end
			end
			for j=1,#vecEliteAbilityOptions do
				if vecEliteAbilityOptions[j] == ASCENSION_ABILITIES_FORCE_LIST[i] then
					table.remove( vecEliteAbilityOptions, j )
					break
				end
			end			
		end
		nStart = #ASCENSION_ABILITIES_FORCE_LIST + 1
	end

	-- Pick elite-only abilities
	if nEliteLevel > 0 then 

		local nDesiredEliteAbilityCount = ELITE_ABILITIES_PER_ASCENSION_LEVEL[ nAscensionLevel + 1 ]
		for i=nStart,nDesiredEliteAbilityCount do
			if #vecEliteAbilityOptions == 0 then
				break
			end

			local nPick = self:RoomRandomInt( 1, #vecEliteAbilityOptions )
			print( "Encounter " .. self.szEncounterName .. " added ELITE ascension ability " .. vecEliteAbilityOptions[nPick] )
			table.insert( self.AscensionAbilities, vecEliteAbilityOptions[nPick] )
			self.ClientData[ "ascension_abilities" ][ tostring(i) ] = vecEliteAbilityOptions[nPick]
			table.remove( vecEliteAbilityOptions, nPick )

			nStart = nStart + 1
		end

	end

	-- Pick ascension abilities
	for i=nStart,nDesiredAbilityCount do
		if #vecAbilityOptions == 0 then
			break
		end

		local nPick = self:RoomRandomInt( 1, #vecAbilityOptions )
		print( "Encounter " .. self.szEncounterName .. " added ascension ability " .. vecAbilityOptions[nPick] )
		table.insert( self.AscensionAbilities, vecAbilityOptions[nPick] )
		self.ClientData[ "ascension_abilities" ][ tostring(i) ] = vecAbilityOptions[nPick]
		table.remove( vecAbilityOptions, nPick )
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:Precache( context )

	-- By default, precache all units referenced by spawners
	for _, hSpawner in pairs( self:GetSpawners() ) do
		hSpawner:Precache( context )
	end

	for _, hPortalSpawner in pairs( self:GetPortalSpawners() ) do
		hPortalSpawner:Precache( context )
	end

	for _, hPortalSpawner in pairs( self.PortalSpawnersV2 ) do
		hPortalSpawner:Precache( context )
	end	

	-- Precache preview units for exit directions
	for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
		local szExitRoomName = self:GetRoom():GetExit( nExitDirection )
		if szExitRoomName ~= nil then
			local hExitRoom = GameRules.Aghanim:GetRoom( szExitRoomName )
			if hExitRoom ~= nil and hExitRoom:GetEncounter():GetPreviewUnit() ~= nil then
				PrecacheUnitByNameSync( hExitRoom:GetEncounter():GetPreviewUnit(), context, -1 )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:OnEncounterLoaded()
	--print( "CMapEncounter:OnEncounterLoaded " .. self.szEncounterName )

	-- Some NPCs require retreat points
	self.RetreatPoints = self:GetRoom():FindAllEntitiesInRoomByName( "retreat_point" )

	-- All spawners can now look for their spawn info targets
	for _, hSpawner in pairs( self:GetSpawners() ) do
		hSpawner:OnEncounterLoaded( self )
	end

	-- find all potential portal locations and then assign them out to the portal spawners
	local PortalLocations = {}
	for _, hPortalSpawner in pairs ( self:GetPortalSpawners() ) do
		local name = hPortalSpawner:GetLocatorName()
		if PortalLocations[name] == nil then
			PortalLocations[name] = {}
			PortalLocations[name] = self:GetRoom():FindAllEntitiesInRoomByName( name )
			ShuffleListInPlace( PortalLocations[name] )
			--print( "Collected " .. #PortalLocations[name] .. " portal locations for name " .. name )
		end
	end

	-- assign each portal spawner a unique spawn location
	for _, hPortalSpawner in pairs ( self:GetPortalSpawners() ) do
		local name = hPortalSpawner:GetLocatorName()
		if #PortalLocations[name] <= 0 then
			print( "ERROR: Can't find a unique portal location for portal spawner named " .. name )
			break
		end

		local portalLocation = PortalLocations[name][1]
		--print( "Grabbing portal named " .. name .. ". Location is " .. portalLocation:GetOrigin().x .. ", " .. portalLocation:GetOrigin().y .. ", " .. portalLocation:GetOrigin().z )
		table.remove( PortalLocations[name], 1 )

		hPortalSpawner:SetLocation( portalLocation:GetOrigin() )
		hPortalSpawner:OnEncounterLoaded( self )
	end

	for _, hPortalSpawner in pairs ( self.PortalSpawnersV2 ) do
		hPortalSpawner:OnEncounterLoaded( self )
	end

	-- We can also look for a boss preview entity
	self:SpawnBossPreviewEntity()

	self:InitializeObjectives()
end


--------------------------------------------------------------------------------

function CMapEncounter:InitializeObjectives()
	if self.hRoom:GetType() == ROOM_TYPE_ENEMY then
		self:AddEncounterObjective( "defeat_all_enemies", 0, 0 ) 
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:Introduce()
	GameRules.Aghanim:GetAnnouncer():OnEncounterSelected( self )
	CustomGameEventManager:Send_ServerToAllClients( "introduce_encounter", self.ClientData )
	self:UpdateClient()
end

--------------------------------------------------------------------------------

function CMapEncounter:AddEncounterObjective( szKey, nValue, nGoal )
	local Objective = {}
	Objective[ "name" ] = szKey
	Objective[ "value" ] = nValue
	Objective[ "goal" ] = nGoal
	Objective[ "order" ] = self.nObjectiveNumber
	self.nObjectiveNumber = self.nObjectiveNumber + 1

	self.ClientData[ "objectives" ][ szKey ] = Objective
	self:UpdateClient()
end

--------------------------------------------------------------------------------
-- nGoal can be purposely nil to skip changing the goal
--------------------------------------------------------------------------------
function CMapEncounter:UpdateEncounterObjective( szKey, nValue, nGoal )
	if self.ClientData[ "objectives" ][ szKey ] == nil then
		return
	end

	self.ClientData[ "objectives" ][ szKey ][ "value" ] = nValue
	if nGoal ~= nil then
		self.ClientData[ "objectives" ][ szKey ][ "goal" ] = nGoal
	end
	self:UpdateClient()
end

--------------------------------------------------------------------------------

function CMapEncounter:GetEncounterObjectiveProgress( szKey )
	if self.ClientData[ "objectives" ][ szKey ] == nil then
		return -1
	end

	return self.ClientData[ "objectives" ][ szKey ][ "value" ]
end

--------------------------------------------------------------------------------

function CMapEncounter:GetEncounterObjectiveGoal( szKey )
	if self.ClientData[ "objectives" ][ szKey ] == nil then
		return -1
	end

	return self.ClientData[ "objectives" ][ szKey ][ "goal" ]
end

--------------------------------------------------------------------------------

function CMapEncounter:UpdateClient()
	CustomNetTables:SetTableValue( "encounter_state", "depth", { tostring( self.hRoom:GetDepth() ) } )
	CustomNetTables:SetTableValue( "encounter_state", tostring( self.hRoom:GetDepth() ), self.ClientData )
end

--------------------------------------------------------------------------------

function CMapEncounter:SpawnBossPreviewEntity()

	local hBossPreviewEntity = self:GetRoom():FindAllEntitiesInRoomByName( "encounter_boss_preview_locator", false )
	if #hBossPreviewEntity == 0 then
		return
	end

	local nAct = self:GetRoom():GetAct()
	--print( "CMapEncounter:SpawnBossPreviewEntity() " .. nAct )

	-- Find the boss room for the act this encounter is in
	local hBossRoom = nil
  	for _,room in pairs( GameRules.Aghanim:GetRoomList() ) do
  
  		if room:GetType() == ROOM_TYPE_BOSS and room:GetAct() == nAct then
  			hBossRoom = room
  			break;
  		end
	end

	if hBossRoom == nil then
		return
	end

	local strPreviewUnit = hBossRoom:GetEncounter():GetPreviewUnit()
	local bossPreviewTable = 
	{ 	
		BossUnit = strPreviewUnit, 
		BossModelScale = ENCOUNTER_PREVIEW_SCALES[ strPreviewUnit ],
		ExtraModelScale = 2,
		EncounterType = ROOM_TYPE_BOSS,
	}

	if bossPreviewTable.BossModelScale == nil then
		bossPreviewTable.BossModelScale = 1.0
	end

	for i=1,#hBossPreviewEntity do
		local vOrigin = hBossPreviewEntity[i]:GetAbsOrigin()
		local vAngles = hBossPreviewEntity[i]:GetAnglesAsVector()
		bossPreviewTable.origin = tostring( vOrigin.x ) .. " " .. tostring( vOrigin.y ) .. " " .. tostring( vOrigin.z )
		bossPreviewTable.angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z )

		SpawnEntityFromTableAsynchronous( "dota_aghsfort_boss_preview", bossPreviewTable, nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:IsComplete()
	if self.flStartTime == -1 then
		return false
	end

	return self.bCompleted
end

--------------------------------------------------------------------------------

function CMapEncounter:CheckForCompletion()
	if not self:HasRemainingEnemies() and self:AreScheduledSpawnsComplete() and not self:HasAnyPortals() then
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter:ShouldAutoStartGlobalAscensionAbilities()
	return true
end

--------------------------------------------------------------------------------

function CMapEncounter:GetAscensionAbilities()
	return self.AscensionAbilities
end

--------------------------------------------------------------------------------

function CMapEncounter:StartGlobalAscensionAbilities()

	-- Protect against double calls
	if self.hDummyAscensionCaster ~= nil then
		return
	end

	if #self.AscensionAbilities > 0 then

		local vOrigin = self:GetRoom():GetOrigin()
		local dummyTable = 
		{ 	
			targetname = "ascension_global_caster",
			MapUnitName = "npc_dota_dummy_caster", 
			teamnumber = DOTA_TEAM_BADGUYS,
		}
		self.hDummyAscensionCaster = CreateUnitFromTable( dummyTable, vOrigin )
	  	if self.hDummyAscensionCaster ~= nil then
	  		self:AddAscensionAbilities( self.hDummyAscensionCaster )
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:Start()
	print( string.format( "Encounter %s starting..\n", self.szEncounterName ) )
	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		PlayerResource:SetCustomIntParam( nPlayerID, self.hRoom:GetDepth() - 1 )
	end

	for i=0,GameRules:NumDroppedItems()-1 do
		local hDroppedItem = GameRules:GetDroppedItem( i ) 
		if hDroppedItem then
			local hContainedItem = hDroppedItem:GetContainedItem()
			if hContainedItem and hContainedItem:IsNeutralDrop() then
				PlayerResource:AddNeutralItemToStash( 0, DOTA_TEAM_GOODGUYS, hContainedItem )

				local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/neutralitem_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil ) 
				ParticleManager:SetParticleControl( nFXIndex, 0, hDroppedItem:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "NeutralItem.TeleportToStash", hDroppedItem )

				UTIL_Remove( hDroppedItem )
			end
		end
	end

	local nEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( getclass( self ), "OnEntityKilled" ), self )
	table.insert( self.EventListeners, nEntityKilledGameEvent )

	local nTriggerStartTouchEvent = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( getclass( self ), "OnTriggerStartTouch" ), self )
	table.insert( self.EventListeners, nTriggerStartTouchEvent )

	local nTriggerEndTouchEvent = ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( getclass( self ), "OnTriggerEndTouch" ), self )
	table.insert( self.EventListeners, nTriggerEndTouchEvent )
	
	GameRules.Aghanim:GetAnnouncer():OnEncounterStarted( self )
	
	self.nMaxSpawnedUnitCount = 0
	self.nUnitsRemainingForRewardDrops = 0
	if self.bCalculateRewardsFromUnitCount then
		self.nMaxSpawnedUnitCount = self:GetMaxSpawnedUnitCount()
		self.nUnitsRemainingForRewardDrops = self.nMaxSpawnedUnitCount
		if self.nMaxSpawnedUnitCount == 0 then
			print( "*** WARNING : Encounter " .. self.szEncounterName .. " indicates 0 units to be spawned.. Check your GetMaxSpawnedUnitCount()" )
		end
	end

	self.flStartTime = GameRules:GetGameTime()

	if self:IsWaitingToSpawnPortals() == false then
		for _,PortalSpawner in pairs ( self.PortalSpawners ) do
			PortalSpawner:Start( self.flStartTime )
		end
	end

	if self.flEnrageTimer then
		CustomNetTables:SetTableValue( "room_data", "enrage_timer", { active=true, startTime=self.flStartTime, enrageTimer=self.flEnrageTimer } )
	else
		CustomNetTables:SetTableValue( "room_data", "enrage_timer", { active=false } )
	end

	self:SpawnChests()
	self:SpawnBreakableContainers()
	self:SpawnExplosiveBarrels()

	CustomNetTables:SetTableValue( "room_data", "status", { complete=false } )

	if self:ShouldAutoStartGlobalAscensionAbilities() == true then
		self:StartGlobalAscensionAbilities()
	end

	if self.hRoom:GetType() == ROOM_TYPE_ENEMY then
		self.nNumItemsToDrop = GameRules.Aghanim:RollRandomNeutralItemDrops( self )
		self.nNumBPToDrop = self:RoomRandomInt( 0, 2 )
	end

	if self.hRoom:GetType() == ROOM_TYPE_ENEMY or self.hRoom:GetType() == ROOM_TYPE_TRAPS then
		self.nNumFragmentsToDrop = GameRules.Aghanim:RollRandomFragmentDrops()
	end

	self.ClientData[ "start_time" ] = self:GetStartTime() - GameRules.Aghanim:GetExpeditionStartTime()
	CustomNetTables:SetTableValue( "encounter_state", "depth_started", { tostring( self.hRoom:GetDepth() ) } )
	self:UpdateClient()
end

--------------------------------------------------------------------------------

function CMapEncounter:SpawnChests()
	printf( "-----------------------------------" )
	--printf( "CMapEncounter:SpawnChests()" )

	--PrintTable( TreasureChestData, "  " )

	for i, chestData in ipairs( TreasureChestData ) do
		--print( "" )
		--print( "Looking at chestData #" .. i )
		if ( chestData.szSpawnerName == nil ) then
			printf( "ERROR -- CMapEncounter:SpawnChests(): No szSpawnerName specified for this chest." )
		end

		local fSpawnChance = chestData.fSpawnChance
		if fSpawnChance == nil or fSpawnChance <= 0 then
			printf( "ERROR -- CMapEncounter:SpawnChests: Treasure chest spawn chance is not valid." )
		end

		if chestData.nMaxSpawnDistance == nil or chestData.nMaxSpawnDistance < 0 then
			printf( "WARNING -- CMapEncounter:SpawnChests: nMaxSpawnDistance is not valid. Defaulting to 0." )
			chestData.nMaxSpawnDistance = 0
		end

		local nChestsSpawned = 0

		-- printf( "CMapEncounter:SpawnChests - chestData.szSpawnerName == %s", chestData.szSpawnerName )
		local hSpawners = self:GetRoom():FindAllEntitiesInRoomByName( chestData.szSpawnerName, false )
		for _, hSpawner in pairs( hSpawners ) do
			printf( "Iterating over hSpawners" )
			if nChestsSpawned < self.nChestsToSpawn then
				local vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, chestData.nMaxSpawnDistance ) )

				local fThreshold = 1 - fSpawnChance
				local bSpawnChest = self:RoomRandomFloat( 0, 1 ) >= fThreshold

				-- Force chest spawns if we'd run out of spawners otherwise
				local nSpawnersRemaining = #hSpawners - i
				local nChestsNeeded = self.nChestsToSpawn - nChestsSpawned
				if nSpawnersRemaining <= nChestsNeeded then
					--printf( "  %d spawners remaining and still need to spawn %d chests, so force the rest of the spawners to spawn chests", nSpawnersRemaining, nChestsNeeded )
					bSpawnChest = true
				end

				if bSpawnChest then
					local hUnit = CreateUnitByName( chestData.szNPCName, vSpawnLoc, true, nil, nil, DOTA_TEAM_GOODGUYS )
					if hUnit ~= nil then
						local vSpawnerForward = hSpawner:GetForwardVector()
						hUnit:SetForwardVector( vSpawnerForward )

						-- print( "CMapEncounter:SpawnChests - Created chest unit named " .. hUnit:GetUnitName() )
						hUnit.fNeutralItemChance = chestData.fNeutralItemChance
						hUnit.nMinNeutralItems = chestData.nMinNeutralItems
						hUnit.nMaxNeutralItems = chestData.nMaxNeutralItems
						hUnit.fItemChance = chestData.fItemChance
						hUnit.nMinItems = chestData.nMinItems
						hUnit.nMaxItems = chestData.nMaxItems
						hUnit.Items = chestData.Items
						hUnit.fTrapChance = chestData.fTrapChance
						hUnit.nTrapLevel = chestData.nTrapLevel
						hUnit.szTraps = chestData.szTraps
						hUnit.Encounter = self
						self:RegisterTreasureItem( hUnit )
					else
						printf( "ERROR -- CMapEncounter:SpawnChests: Failed to spawn chest named \"%s\"", chestData.szNPCName )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:SpawnBreakableContainers()
	--print( "-----------------------------------" )
	--print( "CMapEncounter:SpawnBreakableContainers()" )
	--PrintTable( BreakablesData, "   " )

	for i, breakableData in ipairs( BreakablesData ) do
		--print( "" )
		--print( "Looking at breakableData #" .. i )
		if ( breakableData.szSpawnerName == nil ) then
			printf( "CMapEncounter:SpawnBreakableContainers() - ERROR: No szSpawnerName specified for this breakable container." )
			return
		end

		local fSpawnChance = breakableData.fSpawnChance
		if fSpawnChance == nil or fSpawnChance <= 0 then
			printf( "CMapEncounter:SpawnBreakableContainers - ERROR: Breakable container spawn chance is not valid" )
			return
		end

		if breakableData.nMaxSpawnDistance == nil or breakableData.nMaxSpawnDistance < 0 then
			printf( "CMapEncounter:SpawnBreakableContainers - ERROR: nMaxSpawnDistance is not valid." )
			return
		end

		local nCratesSpawned = 0

		--printf( "This room wants to spawn %d crates", self.nCratesToSpawn )

		if ( breakableData.szSpawnerName ~= nil ) then
			--print( "breakableData.szSpawnerName == " .. breakableData.szSpawnerName )
			local hSpawners = self:GetRoom():FindAllEntitiesInRoomByName( breakableData.szSpawnerName, false )
			for i, hSpawner in pairs( hSpawners ) do
				if nCratesSpawned < self.nCratesToSpawn then
					local vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, breakableData.nMaxSpawnDistance ) )

					local fThreshold = 1 - fSpawnChance
					local bSpawnBreakable = self:RoomRandomFloat( 0, 1 ) >= fThreshold

					-- Force crate spawns if we'd run out of spawners otherwise
					local nSpawnersRemaining = #hSpawners - i
					local nCratesNeeded = self.nCratesToSpawn - nCratesSpawned
					if nSpawnersRemaining <= nCratesNeeded then
						--printf( "  %d spawners remaining and still need to spawn %d crates, so force the rest of the spawners to spawn crates", nSpawnersRemaining, nCratesNeeded )
						bSpawnBreakable = true
					end

					if bSpawnBreakable then

						local vAngles = VectorAngles( RandomVector( 1 ) )
						local breakableTable = 
						{ 	
							MapUnitName = breakableData.szNPCName, 
							origin = tostring( vSpawnLoc.x ) .. " " .. tostring( vSpawnLoc.y ) .. " " .. tostring( vSpawnLoc.z ),
							angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z ),
							teamnumber = DOTA_TEAM_BADGUYS,
							NeverMoveToClearSpace = false,
						}
						local hUnit = CreateUnitFromTable( breakableTable, vSpawnLoc )
						if hUnit ~= nil then
							--print( "Created breakable container unit named " .. hUnit:GetUnitName() )
							hUnit.CommonItems = breakableData.CommonItems
							hUnit.fCommonItemChance = breakableData.fCommonItemChance
							hUnit.MonsterUnits = breakableData.MonsterUnits
							hUnit.fMonsterChance = breakableData.fMonsterChance
							hUnit.RareItems = breakableData.RareItems
							hUnit.fRareItemChance = breakableData.fRareItemChance
							hUnit.nMinGold = breakableData.nMinGold
							hUnit.nMaxGold = breakableData.nMaxGold
							hUnit.fGoldChance = breakableData.fGoldChance
							hUnit:AddNewModifier( hUnit, nil, "modifier_breakable_container", {} )

							table.insert( self.SpawnedBreakables, hUnit )

							nCratesSpawned = nCratesSpawned + 1
							--printf( "  Spawned %d crates", nCratesSpawned )
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:SpawnExplosiveBarrels()
	--printf( "-----------------------------------" )
	--printf( "CMapEncounter:SpawnExplosive()" )
	--PrintTable( ExplosiveBarrelData, "   " )

	for i, barrelData in ipairs( ExplosiveBarrelData ) do
		--printf( "Looking at barrelData #", i )
		if ( barrelData.szSpawnerName == nil ) then
			printf( "CMapEncounter:SpawnExplosiveBarrels() - ERROR: No szSpawnerName specified for this explosive barrel." )
			return
		end

		local fSpawnChance = barrelData.fSpawnChance
		if fSpawnChance == nil or fSpawnChance <= 0 then
			printf( "CMapEncounter:SpawnExplosiveBarrels() - ERROR: Explosive barrel spawn chance is not valid" )
			return
		end

		if barrelData.nMaxSpawnDistance == nil or barrelData.nMaxSpawnDistance < 0 then
			printf( "CMapEncounter:SpawnExplosiveBarrels() - ERROR: nMaxSpawnDistance is not valid." )
			return
		end

		local nExplosiveBarrelsSpawned = 0

		--printf( "This room wants to spawn %d explosive barrels", self.nExplosiveBarrelsToSpawn )

		if ( barrelData.szSpawnerName ~= nil ) then
			--print( "barrelData.szSpawnerName == " .. barrelData.szSpawnerName )
			local hSpawners = self:GetRoom():FindAllEntitiesInRoomByName( barrelData.szSpawnerName, false )
			for i, hSpawner in pairs( hSpawners ) do
				if nExplosiveBarrelsSpawned < self.nExplosiveBarrelsToSpawn then
					local vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, barrelData.nMaxSpawnDistance ) )

					local fThreshold = 1 - fSpawnChance
					local bSpawnBarrel = self:RoomRandomFloat( 0, 1 ) >= fThreshold

					-- Force crate spawns if we'd run out of spawners otherwise
					local nSpawnersRemaining = #hSpawners - i
					local nBarrelsNeeded = self.nExplosiveBarrelsToSpawn - nExplosiveBarrelsSpawned
					if nSpawnersRemaining <= nBarrelsNeeded then
						--printf( "  %d spawners remaining and still need to spawn %d barrels, so force the rest of the spawners to spawn barrels", nSpawnersRemaining, nBarrelsNeeded )
						bSpawnBarrel = true
					end

					if bSpawnBarrel then

						local vAngles = VectorAngles( RandomVector( 1 ) )
						local barrelTable = 
						{ 	
							MapUnitName = barrelData.szNPCName, 
							origin = tostring( vSpawnLoc.x ) .. " " .. tostring( vSpawnLoc.y ) .. " " .. tostring( vSpawnLoc.z ),
							angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z ),
							teamnumber = DOTA_TEAM_BADGUYS,
							NeverMoveToClearSpace = false,
						}
						local hUnit = CreateUnitFromTable( barrelTable, vSpawnLoc )
						if hUnit ~= nil then
							-- Set the barrel's level based on the depth we're in.  It'll use its level to set its
							-- explosion ability level
							local hAbility = hUnit:FindAbilityByName( "aghsfort_explosive_barrel" )
							local nDepth = self.hRoom:GetDepth()
							--printf( "nDepth == %d", nDepth )

							for i = 1, nDepth do
								hAbility:UpgradeAbility( true )
							end

							--printf( "nDepth: %d; explosive barrel ability level: %d", nDepth, hAbility:GetLevel() )

							--local vSpawnerForward = hSpawner:GetForwardVector()
							--hUnit:SetForwardVector( vSpawnerForward )

							--printf( "Created explosive barrel unit named \"%s\"", hUnit:GetUnitName() )
							--hUnit:AddNewModifier( hUnit, nil, "modifier_explosive_barrel", {} )

							table.insert( self.SpawnedExplosiveBarrels, hUnit )

							nExplosiveBarrelsSpawned = nExplosiveBarrelsSpawned + 1
							--printf( "  Spawned %d crates", nExplosiveBarrelsSpawned )
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:OnThink()

	--print( 'CMapEncounter:OnThink()' )
	if self.flStartTime ~= -1 and not self.bCompleted then
		self:TrySpawningUnits()
		self:TrySpawningPortalUnits()
		self:TrySpawningPortalUnitsV2()
		self:TryCompletingMapEncounter()
	end

	if self.flCompletionTime ~= nil and ( GameRules:GetGameTime() - self.flCompletionTime ) > 0.6 then
		self:GenerateRewards()
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:NeedsToThink()
	return self.bHasGeneratedRewards == false or self.bHasSpawnedEndLevelEntities == false
end

--------------------------------------------------------------------------------

function CMapEncounter:TrySpawningPortalUnits()
	--print( "CMapEncounter:TrySpawningPortalUnits" )
	for _,PortalSpawner in pairs ( self.PortalSpawners ) do
		PortalSpawner:TrySpawningUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:RunSpawnSchedule( hSpawner )

	if hSpawner.schedule == nil or hSpawner.schedule.flStartTime < 0 then
		return
	end

	-- Debug visualization of focus path
--	if hSpawner.schedule.spawnFocusPath ~= nil then
--		local flRelativeTime = GameRules:GetGameTime() - hSpawner.schedule.flStartTime
--		local vSpawnFocus = self:ComputeSpawnFocusPosition( hSpawner.schedule.spawnFocusPath, flRelativeTime )
--		DebugDrawCircle( vSpawnFocus, Vector( 0, 255, 0 ), 0, hSpawner.schedule.spawnFocusPath.flRadius, false, 1.0 )
--	end

	-- Try to spawn this wave
	for nWave = hSpawner.schedule.nCurrentWaveIndex, #hSpawner.schedule.waveSchedule do
		local flRelativeTime = GameRules:GetGameTime() - hSpawner.schedule.flStartTime
		if hSpawner.schedule.waveSchedule[nWave].Time > flRelativeTime then
			break
		end
		local nCount = hSpawner.schedule.waveSchedule[nWave].Count
		if nCount == nil or nCount <= 0 then
			nCount = hSpawner:GetSpawnPositionCount()
		end

		-- Used by spawners to force movement around the map
		if hSpawner.schedule.spawnFocusPath ~= nil then
			local vSpawnFocus = self:ComputeSpawnFocusPosition( hSpawner.schedule.spawnFocusPath, flRelativeTime )
			hSpawner:SetSpawnFocus( vSpawnFocus, hSpawner.schedule.spawnFocusPath.flRadius )
		end

		hSpawner:SpawnUnitsFromRandomSpawners( nCount )
		hSpawner.schedule.nCurrentWaveIndex = hSpawner.schedule.nCurrentWaveIndex + 1
	end

end


--------------------------------------------------------------------------------

function CMapEncounter:TrySpawningUnits()
	for _,Spawner in pairs ( self.Spawners ) do
		self:RunSpawnSchedule( Spawner )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:TrySpawningPortalUnitsV2()
	for _,PortalSpawner in pairs ( self.PortalSpawnersV2 ) do

		self:RunSpawnSchedule( PortalSpawner )

		-- This ticks the logic to see if any previously spawned portals need to spawn their units
		PortalSpawner:TrySpawningPortalUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:IsScheduledSpawnComplete( hSpawner )
	if hSpawner.schedule == nil then
		return true
	end

	if hSpawner.schedule.nCurrentWaveIndex <= #hSpawner.schedule.waveSchedule then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function CMapEncounter:AreScheduledSpawnsComplete()
	for _,Spawner in pairs ( self.Spawners ) do
		if self:IsScheduledSpawnComplete( Spawner ) == false then
			return false
		end
	end
	for _,PortalSpawner in pairs ( self.PortalSpawnersV2 ) do
		if self:IsScheduledSpawnComplete( PortalSpawner ) == false then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------

function CMapEncounter:TryCompletingMapEncounter()
	--print( 'CMapEncounter:TryCompletingMapEncounter()' )
	local bCompleted = ( self.bDevForceCompleted == true or self:CheckForCompletion() == true )
	if bCompleted and self:GetRoom():AreAllExitRoomsReady() then
		self.bCompleted = bCompleted
		self.flCompletionTime = GameRules:GetGameTime()

		for i=1,#self.EventListeners do
			StopListeningToGameEvent( self.EventListeners[i] )
			self.EventListeners[i] = nil
		end

		self:DestroyRemainingSpawnedUnits()
		self:ResetHeroState()
		self:SpawnEndLevelEntities()
		self:OnComplete()

		self.hRoom:OnEncounterCompleted()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:RegisterSummonForAghanim()
	if self.hRoom:GetType() == ROOM_TYPE_ENEMY then
		GameRules.Aghanim:RegisterSummonForAghanim( self.hRoom:GetDepth(), self:GetAghanimSummon() )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:OnComplete()
	GameRules.Aghanim:GetAnnouncer():OnEncounterComplete( self )
	
	-- Delete any unclaimed treasures
	for i=1,#self.hTreasureList do
		UTIL_Remove( self.hTreasureList[i] )
	end
	self.hTreasureList = {}

	self:RegisterSummonForAghanim()
	
	--CustomNetTables:SetTableValue( "room_data", "status", { complete=true } )
	CustomGameEventManager:Send_ServerToAllClients( "complete_encounter", self.ClientData )
end

--------------------------------------------------------------------------------

function CMapEncounter:AddSpawner( hSpawner )
	if hSpawner == nil then
		print( "ERROR: AddSpawner called with a nil spawner." )
		return
	end

	if self.Spawners[hSpawner:GetSpawnerName()] ~= nil then
		print ( "WARNING: Multiple identical named spawners ( " .. hSpawner:GetSpawnerName() .. ") added to encounter! ")
		return
	end

	self.Spawners[hSpawner:GetSpawnerName()] = hSpawner
	return hSpawner
end

--------------------------------------------------------------------------------

function CMapEncounter:AddPortalSpawner( hSpawner )
	if hSpawner == nil then
		print( "ERROR: AddPortalSpawner called with a nil spawner." )
		return
	end

	--print( 'Adding Portal Spawner named ' .. hSpawner:GetSpawnerName() .. '. Looking for locator named ' .. hSpawner:GetLocatorName() )

	if self.PortalSpawners[hSpawner:GetSpawnerName()] ~= nil then
		print ( "ERROR: Multiple identical named spawners ( " .. hSpawner:GetSpawnerName() .. ") added to encounter! ")
		return
	end

	self.PortalSpawners[hSpawner:GetSpawnerName()] = hSpawner
	return hSpawner
end

--------------------------------------------------------------------------------

function CMapEncounter:AddPortalSpawnerV2( hSpawner )
	if hSpawner == nil then
		print( "ERROR: AddPortalSpawnerV2 called with a nil spawner." )
		return
	end

	if self.PortalSpawnersV2[hSpawner:GetSpawnerName()] ~= nil then
		print( "ERROR: Multiple identical named spawners ( " .. hSpawner:GetSpawnerName() .. ") added to encounter! ")
		return
	end

	self.PortalSpawnersV2[ hSpawner:GetSpawnerName() ] = hSpawner
	return hSpawner
end

--------------------------------------------------------------------------------

function CMapEncounter:SetPortalTriggerSpawner( szSpawnerName, flDelay )

	if szSpawnerName == nil then
		print( "WARNING: CMapEncounter:SetPortalTriggerSpawner .. illegal to specify nil" )
		return
	end

	if self.Spawners[szSpawnerName] == nil then
		print( "WARNING: CMapEncounter:SetPortalTriggerSpawner specified unknown spawner ( " .. szSpawnerName .. ") in encounter " .. self.szEncounterName .. "! ")
		return
	end

	self.szPortalTriggerSpawner = szSpawnerName
	self.flPortalTriggerDelay = flDelay

	for _, hPortalSpawner in pairs( self.PortalSpawnersV2 ) do
		if hPortalSpawner.schedule ~= nil then
			hPortalSpawner.schedule.bWaitingForTrigger = true
		end
	end	

end

--------------------------------------------------------------------------------

function CMapEncounter:IsWaitingToSpawnPortals()
	return self.szPortalTriggerSpawner ~= nil
end

--------------------------------------------------------------------------------

function CMapEncounter:StartSpawningPortals()

	if self.szPortalTriggerSpawner == nil then
		return
	end

	self.szPortalTriggerSpawner = nil

	for _, hPortalSpawner in pairs( self.PortalSpawnersV2 ) do
		if hPortalSpawner.schedule ~= nil then
			if hPortalSpawner.schedule.bWaitingForTrigger == true then
				hPortalSpawner.schedule.bWaitingForTrigger = false
				hPortalSpawner.schedule.flStartTime = GameRules:GetGameTime() + hPortalSpawner.schedule.flDelay + self.flPortalTriggerDelay
			end
		end
	end	

	for _,PortalSpawner in pairs ( self.PortalSpawners ) do
		PortalSpawner:Start( GameRules:GetGameTime() + self.flPortalTriggerDelay )
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:SetSpawnerSchedule( szSpawnerName, waveScheduleInput )

	if waveScheduleInput == nil then
		waveScheduleInput = { { Time = 0 } }	-- Not specifying count means spawn at all points
	end

	-- Validate the schedule is valid
	local nLastTime = 0
	for i=1,#waveScheduleInput do
		if nLastTime > waveScheduleInput[i].Time then
			print( "ERROR: BeginSpawnerSchedule: Wave schedule ( " .. szSpawnerName .. ") not specified in increasing order of time in encounter " .. self.szEncounterName )
			return
		end
		nLastTime = waveScheduleInput[i].Time
	end

	-- Try to find a spawner in all of the lists to spawn
	local bIsPortal = false
	local hSpawner = self:GetSpawner( szSpawnerName )
	if hSpawner == nil then
		hSpawner = self:GetPortalSpawnerV2( szSpawnerName )
		bIsPortal = true
	end

	if hSpawner == nil then
		print( "ERROR: BeginSpawnerSchedule: Spawner ( " .. szSpawnerName .. ") isn't found in this encounter " .. self.szEncounterName )
		return
	end

	hSpawner.schedule =
	{
		nCurrentWaveIndex = 1,
		waveSchedule = waveScheduleInput,
		flStartTime = -1,
		bWaitingForTrigger = ( bIsPortal == true ) and self:IsWaitingToSpawnPortals()			
	}

end

--------------------------------------------------------------------------------

function CMapEncounter:StartAllSpawnerSchedules( flDelay )

	-- Start everything up
	for _, hSpawner in pairs( self:GetSpawners() ) do
		if hSpawner.schedule ~= nil then
			hSpawner.schedule.flStartTime = GameRules:GetGameTime() + flDelay
		end
	end

	for _, hPortalSpawner in pairs( self.PortalSpawnersV2 ) do
		if hPortalSpawner.schedule ~= nil then
			if hPortalSpawner.schedule.bWaitingForTrigger == true then
				hPortalSpawner.schedule.flDelay = flDelay
			else		
				hPortalSpawner.schedule.flStartTime = GameRules:GetGameTime() + flDelay
			end
		end
	end	

end

--------------------------------------------------------------------------------

function CMapEncounter:StartSpawnerSchedule( szSpawnerName, flDelay )

	-- Try to find a spawner in all of the lists to spawn
	local bIsPortal = false
	local hSpawner = self:GetSpawner( szSpawnerName )
	if hSpawner == nil then
		bIsPortal = true
		hSpawner = self:GetPortalSpawnerV2( szSpawnerName )
	end
	
	if hSpawner == nil then
		print( "ERROR: StartSpawnerSchedule: Spawner ( " .. szSpawnerName .. ") isn't found in this encounter!" )
		return
	end

	if hSpawner.schedule == nil then
		print( "ERROR: StartSpawnerSchedule: Spawner ( " .. szSpawnerName .. ") doesn't have a specified schedule!" )
		return
	end

	if hSpawner.schedule.bWaitingForTrigger == true then
		hSpawner.schedule.flDelay = flDelay
		return
	end

	hSpawner.schedule.flStartTime = GameRules:GetGameTime() + flDelay

end

--------------------------------------------------------------------------------

function CMapEncounter:GenerateSpawnFocusPath( szSpawnerName, flSpeed, flDesiredRadiusInput, flMaxTime )

	-- For portal spawner V2s, we want to force the player to move through the space.
	-- We do this by moving the region where portals are more likely to appear
	local hSpawner = self:GetPortalSpawnerV2( szSpawnerName )
	if hSpawner == nil then
		print( "ERROR: GenerateSpawnFocusPath: Spawner ( " .. szSpawnerName .. ") isn't found in encounter " .. self.szEncounterName )
		return nil
	end

	-- If they didn't specify a max time, but we have a schedule, figure it out automatically
	if flMaxTime == nil or flMaxTime <= 0 then
		if hSpawner.schedule == nil then
			print( "ERROR: GenerateSpawnFocusPath: Didn't specify duration for " .. szSpawnerName .. " in encounter " .. self.szEncounterName )
			return nil
		end
		flMaxTime = hSpawner.schedule.waveSchedule[ #hSpawner.schedule.waveSchedule ].Time
	end

	local spawnFocusPath =
	{
		flRadius = flDesiredRadiusInput,
		vecPathNodes = {}
	}

	local flMaxDist = flMaxTime * flSpeed 
	local flCurrDist = 0
	local flTime = 0
	local vLastPos = nil
	while flCurrDist < flMaxDist do

		local vecSpawnPositions = deepcopy( hSpawner:GetSpawnPositions() )
		local nIndex = math.random( 1, #vecSpawnPositions )
		while #vecSpawnPositions > 1 and vLastPos ~= nil and 
			( ( vecSpawnPositions[nIndex]:GetAbsOrigin() - vLastPos ):Length2D() < flDesiredRadiusInput ) do
			table.remove( vecSpawnPositions, nIndex )
			nIndex = math.random( 1, #vecSpawnPositions )
		end

		local bIdenticalPoint = false
		local vNewPos = vecSpawnPositions[nIndex]:GetAbsOrigin()
		if vLastPos ~= nil then
			local flDist = ( vNewPos - vLastPos ):Length2D()
			flCurrDist = flCurrDist + flDist
			flTime = flCurrDist / flSpeed
			if flDist == 0 then
				bIdenticalPoint = true
			end
		end
		vLastPos = vNewPos
		if bIdenticalPoint == false then
			table.insert( spawnFocusPath.vecPathNodes, { Time = flTime, Position = vNewPos } )
		end
	
	end

	return spawnFocusPath
end

--------------------------------------------------------------------------------

function CMapEncounter:AssignSpawnFocusPath( szSpawnerName, spawnerFocusPathInput )

	-- Try to find a spawner in all of the lists to spawn
	local hSpawner = self:GetPortalSpawnerV2( szSpawnerName )
	
	if hSpawner == nil then
		print( "ERROR: AssignSpawnFocusPath: Spawner ( " .. szSpawnerName .. ") isn't found in this encounter!" )
		return
	end

	if hSpawner.schedule == nil then
		print( "ERROR: StartSpawnerSchedule: Spawner ( " .. szSpawnerName .. ") doesn't have a specified schedule!" )
		return
	end

	hSpawner.schedule.spawnFocusPath = spawnerFocusPathInput

end

--------------------------------------------------------------------------------

function CMapEncounter:ComputeSpawnFocusPosition( spawnFocusPath, flTime )

	for i=1,#spawnFocusPath.vecPathNodes do
		if flTime < spawnFocusPath.vecPathNodes[i].Time then
			if i == 1 then
				return spawnFocusPath.vecPathNodes[i].Position	
			end

			-- Lerp
			local prev = spawnFocusPath.vecPathNodes[i-1]
			local next = spawnFocusPath.vecPathNodes[i]
			local t = ( flTime - prev.Time ) / ( next.Time - prev.Time )
			local vDelta = next.Position - prev.Position
			local v = Vector( prev.Position.x + vDelta.x * t, prev.Position.y + vDelta.y * t, prev.Position.z + vDelta.z * t )
			return v
		end
	end

	return spawnFocusPath.vecPathNodes[#spawnFocusPath.vecPathNodes].Position
end

--------------------------------------------------------------------------------

function CMapEncounter:ComputeUnitsSpawnedBySchedule( hSpawner )

	if hSpawner.schedule == nil then
		return 0
	end

	local nCount = 0

	local nUnitsPerPortal = hSpawner:GetSpawnCountPerSpawnPosition()
	local nSpawnPositionCount = hSpawner:GetSpawnPositionCount()

	for j=1,#hSpawner.schedule.waveSchedule do
		local wave = hSpawner.schedule.waveSchedule[j]
		local nWaveCount = wave.Count
		if nWaveCount == nil or nWaveCount <= 0 then
			nWaveCount = nSpawnPositionCount
		end
		nCount = nCount + nWaveCount * nUnitsPerPortal
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter:GetMaxSpawnedUnitCount()

	local nCount = 0

	for _,Spawner in pairs ( self.Spawners ) do
		nCount = nCount + self:ComputeUnitsSpawnedBySchedule( Spawner )
	end

	for _,PortalSpawner in pairs ( self.PortalSpawnersV2 ) do
		nCount = nCount + self:ComputeUnitsSpawnedBySchedule( PortalSpawner )
	end

	for _,PortalSpawner in pairs ( self.PortalSpawners ) do
		for _,rgUnitInfo in pairs ( PortalSpawner.rgUnitsInfo ) do
			nCount = nCount + ( rgUnitInfo.Count * PortalSpawner:GetNumSpawnsRemaining() )
		end
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter:MustKillForEncounterCompletion( hEnemyCreature )
	return true
end

---------------------------------------------------------

function CMapEncounter:SuppressRewardsOnDeath( hEnemyCreature )
	hEnemyCreature.bSuppressRewardsOnDeath = true
end

---------------------------------------------------------

function CMapEncounter:AddAscensionAbilities( hEnemyCreature )

	if hEnemyCreature:IsBuilding() == true then
		return
	end

	if hEnemyCreature:GetUnitName() == "npc_dota_explosive_barrel" then
		return
	end

	local nAbilityLevel = self:GetRoom():GetEliteRank() + GameRules.Aghanim:GetAscensionLevel()

	local bIsGlobal = IsGlobalAscensionCaster( hEnemyCreature )

	-- Ascension abilities make creatures harder.
	-- ability_ascension is always granted and just deals with generic attributes like damage
	-- The other abilities are more flavorful and specific and may be randomly selected
	-- We must level it up once since all other abilities already were levelled on spawn
	-- For the stats 
	if bIsGlobal == false then
		local hAbility = hEnemyCreature:AddAbility( "ability_ascension" )
		hAbility:UpgradeAbility( true )

		-- Bosses do not use ascension modifiers, but do want general ascension scaling for their minions.
		if self.hRoom:GetType() == ROOM_TYPE_BOSS then
			if ( GameRules.Aghanim.bIsInTournamentMode == false or #TRIALS_BOSS_ASCENSION_ABILITIES == 0 ) and GameRules.Aghanim:GetAscensionLevel() < AGHANIM_ASCENSION_APEX_MAGE then
				if nAbilityLevel > 0 then
					hEnemyCreature:CreatureLevelUp( nAbilityLevel )
				end
				return
			end
		end
	end
	

	for i=1,#self.AscensionAbilities do

		local abilityInfo = ASCENSION_ABILITIES[ self.AscensionAbilities[i] ]
		local nAbilityType = abilityInfo.nType
		if nAbilityType == nil then
			nAbilityType = ASCENSION_ABILITY_CAPTAINS_ONLY
		end

		local bRequiresGlobal = ( nAbilityType == ASCENSION_ABILITY_GLOBAL )
		if bIsGlobal ~= bRequiresGlobal then
			goto continue 
		end

		local bIsCaptain = hEnemyCreature:IsConsideredHero() or hEnemyCreature:IsBoss()

		if nAbilityType == ASCENSION_ABILITY_CAPTAINS_ONLY and bIsCaptain == false then
			goto continue
		elseif nAbilityType == ASCENSION_ABILITY_NON_CAPTAINS_ONLY and bIsCaptain == true then
			goto continue
		end

		--print( "Ascension adding ability " .. self.AscensionAbilities[i] .. " to unit " .. hEnemyCreature:GetUnitName() )
		hAbility = hEnemyCreature:AddAbility( self.AscensionAbilities[i] )
		hAbility:UpgradeAbility( true )

		-- This is the glue that causes these abilities to autocast, but passive abilities don't need to do this
		if IsServer() and bitand( hAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_PASSIVE ) == 0 then
 
			-- This makes the global abilities not just autostart
			if bIsGlobal then
				hAbility:StartCooldown( -1 )
			end

			local kv = 
			{
				cast_behavior = abilityInfo.nCastBehavior,
				target_type = abilityInfo.nTargetType,
				health_percent = abilityInfo.flHealthPercent,
				range = abilityInfo.nRange,
			}

			if kv.cast_behavior == nil then
				kv.cast_behavior = ASCENSION_CAST_WHEN_COOLDOWN_READY
			end
			if kv.target_type == nil then
				kv.target_type = ASCENSION_TARGET_NO_TARGET
			end
			if kv.health_percent == nil then
				kv.health_percent = 25
			end

			hEnemyCreature:AddNewModifier( hEnemyCreature, hAbility, "modifier_passive_autocast", kv )
		end		

		::continue::
	end

	if nAbilityLevel > 0 then
		hEnemyCreature:CreatureLevelUp( nAbilityLevel )
	end
end

---------------------------------------------------------

function CMapEncounter:OnEnemyCreatureSpawned( hEnemyCreature )

	if hEnemyCreature.Encounter ~= nil then
		return
	end

	-- Remove normal last hit gold / xp
	hEnemyCreature:SetMinimumGoldBounty( 0 )
	hEnemyCreature:SetMaximumGoldBounty( 0 )
	hEnemyCreature:SetDeathXP( 0 )

	-- Filter out creatures that aren't really creatures
	if hEnemyCreature:GetUnitName() == "npc_dota_explosive_barrel" then
		self:SuppressRewardsOnDeath( hEnemyCreature )
		return
	end

	hEnemyCreature.Encounter = self

	local bIsDummy = hEnemyCreature:GetUnitName() == "npc_dota_dummy_caster"
	if not bIsDummy then
		if hEnemyCreature:GetUnitName() ~= "npc_dota_creature_bonus_chicken" and hEnemyCreature:GetUnitName() ~= "npc_dota_creature_bonus_greevil" then
			hEnemyCreature:AddNewModifier( hEnemyCreature, nil, "modifier_monster_leash", {} )
		end
		self:AddAscensionAbilities( hEnemyCreature )
	end

	local bIsGlobal = IsGlobalAscensionCaster( hEnemyCreature )
	if not bIsGlobal and self:MustKillForEncounterCompletion( hEnemyCreature ) == true then
		table.insert( self.SpawnedEnemies, hEnemyCreature )
	else
		table.insert( self.SpawnedSecondaryEnemies, hEnemyCreature )
		self:SuppressRewardsOnDeath( hEnemyCreature )
	end

	if hEnemyCreature:IsConsideredHero() then
		hEnemyCreature:AddNewModifier( hEnemyCreature, nil, "modifier_ability_cast_warning", kv )
	end
end

---------------------------------------------------------
-- spawner_finished
-- * spawner_name
---------------------------------------------------------
function CMapEncounter:OnSpawnerFinished( hSpawner, hSpawnedUnits )

	-- NOTE: This is called *after* OnEnemyCreatureSpawned, and will be called
	-- On the same units. The difference is that OnEnemyCreatureSpawned is called
	-- for secondary summoned units not spawned by the spawner also *and*
	-- OnEnemyCreatureSpawned is called prior to OnSpawnerFinished
	local bIsPortalTriggerUnit = ( self.szPortalTriggerSpawner ~= nil ) and ( self.szPortalTriggerSpawner == hSpawner:GetSpawnerName() )

	for _,hSpawnedUnit in pairs ( hSpawnedUnits ) do
		if hSpawnedUnit ~= nil then
			hSpawnedUnit:SetRequiresReachingEndPath( true )	-- this ensures that our spawned dudes won't shut down while getting to their goal ent

			if bIsPortalTriggerUnit == true then
				table.insert( self.SpawnedPortalTriggerUnits, hSpawnedUnit )
			end			
		end
	end
end

---------------------------------------------------------

function CMapEncounter:SetInitialGoalEntityToNearestHero( hSpawnedUnit )

	local hNearestHero = nil
	local flNearestDistance = 1000000
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do

		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero ~= nil and hPlayerHero:IsAlive() then
				local flDist = ( hPlayerHero:GetAbsOrigin() - hSpawnedUnit:GetAbsOrigin() ):Length2D()
				if flDist < flNearestDistance then
					flDist = flNearestDistance
					hNearestHero = hPlayerHero
				end
			end			
		end

	end

	if hNearestHero ~= nil then
		hSpawnedUnit:SetInitialGoalEntity( hNearestHero )
	end

end

---------------------------------------------------------
-- Grants rewards for killing N units
---------------------------------------------------------
function CMapEncounter:GrantRewardsForKill( hVictim, hAttacker, nUnitCount )

	-- Distribute using fixed rewards
	if hVictim.bSuppressRewardsOnDeath == nil or hVictim.bSuppressRewardsOnDeath == false then

		if self.bCalculateRewardsFromUnitCount and self.nMaxSpawnedUnitCount > 0 then

			if self.nRemainingXPFromEnemies > 0 then

				local nDeathXP = math.floor( nUnitCount * self.nTotalXPFromEnemies / self.nMaxSpawnedUnitCount )
				local nXPPerHero = math.min( self.nRemainingXPFromEnemies, nDeathXP )

				local Heroes = HeroList:GetAllHeroes()
				for _,Hero in pairs ( Heroes ) do
					if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
						Hero:AddExperience( nXPPerHero, DOTA_ModifyXP_CreepKill, false, true )
					end
				end
				self.nRemainingXPFromEnemies = math.max( 0, self.nRemainingXPFromEnemies - nXPPerHero )
			end

			if self.nRemainingGoldFromEnemies > 0 then

				local nMinGoldBounty = math.floor( 0.8 * self.nTotalGoldFromEnemies / self.nMaxSpawnedUnitCount )
				local nMaxGoldBounty = math.ceil( 1.2 * self.nTotalGoldFromEnemies / self.nMaxSpawnedUnitCount )
				local nGoldToDrop = 0 
				for i = 1,nUnitCount do
					nGoldToDrop = nGoldToDrop + math.random( nMinGoldBounty, nMaxGoldBounty )
				end
				nGoldToDrop = math.min( self.nRemainingGoldFromEnemies, nGoldToDrop )
				nGoldToDrop = math.floor( nGoldToDrop * 100 / GOLD_BAG_DROP_PCT ) -- Make it so with the randomness, we get roughly what we expect
				if math.random( 1, 100 ) <= GOLD_BAG_DROP_PCT and nGoldToDrop > 0 then
					local newItem = CreateItem( "item_bag_of_gold", nil, nil )
					newItem:SetPurchaseTime( 0 )
					newItem:SetCurrentCharges( nGoldToDrop * AGHANIM_PLAYERS )
					local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
					local dropTarget = hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
					newItem:LaunchLoot( true, 150, 0.75, dropTarget )
					self.nRemainingGoldFromEnemies = self.nRemainingGoldFromEnemies - nGoldToDrop
				end
			end

		end

		-- Logic for nUnitsRemainingForRewardDrops makes it more likely 
		-- that we drop the lives and items the more units we kill
		if self.nUnitsRemainingForRewardDrops >= 0 then
			self.nUnitsRemainingForRewardDrops = self.nUnitsRemainingForRewardDrops - nUnitCount 
			self.nUnitsRemainingForRewardDrops = math.max( 0, self.nUnitsRemainingForRewardDrops )
		end

		local nEstimatedUnitCount = self.nUnitsRemainingForRewardDrops
		if nEstimatedUnitCount <= 0 then
			nEstimatedUnitCount = max( #self.SpawnedEnemies, 1 )
		end

		if self.nNumItemsToDrop > 0 then
			local nPct = math.max( 100 / nEstimatedUnitCount, 1 )
			if RollPercentage( nPct ) then
				self:DropNeutralItemFromUnit( hVictim, hAttacker, true )
				self.nNumItemsToDrop = self.nNumItemsToDrop - 1
			end
		end

		if self.nNumBPToDrop > 0 then
			local nPct = math.max( 100 / nEstimatedUnitCount, 1 )
			if RollPercentage( nPct ) then
				self:DropCurrencyFromUnit( hVictim, hAttacker, RandomInt( BATTLE_POINT_MIN_DROP_VALUE, BATTLE_POINT_MAX_DROP_VALUE ), true, false )
				self.nNumBPToDrop = self.nNumBPToDrop - 1
			end
		end

		if self.nNumFragmentsToDrop > 0 then
			local nPct = math.max( 100 / nEstimatedUnitCount, 1 )
			if RollPercentage( nPct ) then
				self:DropCurrencyFromUnit( hVictim, hAttacker, self:GetArcaneFragmentDropValue(), false, false )
				self.nNumFragmentsToDrop = self.nNumFragmentsToDrop - 1
			end
		end
	end

	-- Always drop potions, even if other rewards are suppressed
	local nHealthPct = HEALTH_POTION_DROP_PCT
	local nManaPct = MANA_POTION_DROP_PCT
	if hVictim.bBossMinion ~= nil and hVictim.bBossMinion == true then
		nHealthPct = nHealthPct * 2
		nManaPct = nManaPct * 2
	end
	if RollPercentage( nHealthPct ) then
		local newItem = CreateItem( "item_health_potion", nil, nil )
		newItem:SetPurchaseTime( 0 )
		if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
			item:SetStacksWithOtherOwners( true )
		end
		local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
		local dropTarget = hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
		newItem:LaunchLoot( true, 300, 0.75, dropTarget )
	end

	if RollPercentage( nManaPct ) then
		local newItem = CreateItem( "item_mana_potion", nil, nil )
		newItem:SetPurchaseTime( 0 )
		if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
			item:SetStacksWithOtherOwners( true )
		end
		local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
		local dropTarget = hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
		newItem:LaunchLoot( true, 300, 0.75, dropTarget )
	end

end


---------------------------------------------------------
-- entity_killed
-- * entindex_killed
-- * entindex_attacker
-- * entindex_inflictor
-- * damagebits
---------------------------------------------------------

function CMapEncounter:OnEntityKilled( event )
	local hVictim = nil
	local hAttacker = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end

	if hVictim == nil then
		return
	end

	if hVictim:IsReincarnating() then
		return
	end

	if hVictim:IsCreature() then

		if hAttacker and hAttacker:IsOwnedByAnyPlayer() then
			EmitSoundOnClient( "DarkMoonLastHit", hAttacker:GetPlayerOwner() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/dark_moon/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hVictim, hAttacker:GetPlayerOwner() ) )

			GameRules.Aghanim:RegisterPlayerKillStat( hAttacker:GetPlayerOwnerID(), self.hRoom:GetDepth() )			
		end

		if hVictim:IsConsideredHero() or hVictim:IsBoss() then
			GameRules.Aghanim:GetAnnouncer():OnCreatureKilled( self, hVictim )
		end

		-- Distribute using fixed rewards
		self:GrantRewardsForKill( hVictim, hAttacker, 1 )

	end

	if self.szPortalTriggerSpawner ~= nil then
		for k,hSpawnedEnemy in pairs ( self.SpawnedPortalTriggerUnits ) do
			if hSpawnedEnemy == hVictim then
				table.remove( self.SpawnedPortalTriggerUnits, k )
			end
		end
		if #self.SpawnedPortalTriggerUnits == 0 then
			self:StartSpawningPortals()
		end
	end

	if hVictim.bSuppressRewardsOnDeath == nil or hVictim.bSuppressRewardsOnDeath == false then
		for k,hSpawnedEnemy in pairs ( self.SpawnedEnemies ) do
			if hSpawnedEnemy == hVictim then
				self.nKilledEnemies = self.nKilledEnemies + 1
				table.remove( self.SpawnedEnemies, k )
				self:OnRequiredEnemyKilled( hAttacker, hVictim )
				--print( "Remaining enemies: " .. #self.SpawnedEnemies )
			end
		end
	else
		for k,hSpawnedSecondaryEnemy in pairs ( self.SpawnedSecondaryEnemies ) do
			if hSpawnedSecondaryEnemy == hVictim then
				self.nKilledSecondaryEnemies = self.nKilledSecondaryEnemies + 1
				self:OnSecondaryEnemyKilled( hAttacker, hVictim )
				table.remove( self.SpawnedSecondaryEnemies, k )
				--print( "Remaining enemies: " .. #self.SpawnedEnemies )
			end
		end
	end

	-- TODO		
--[[	if hVictim:IsBuilding() then
		if hVictim:GetUnitName() == "npc_aghsfort_dark_portal" then
			local nPortalsCountBefore = self:GetRemainingPortalCount() + 1
			for k,PortalSpawner in pairs ( self.PortalSpawners ) do
				if PortalSpawner.Portal.hPortalEnt == hVictim then
					if PortalSpawner.Portal.nWarningFX ~= nil then
						ParticleManager:DestroyParticle( PortalSpawner.Portal.nWarningFX, false )
						PortalSpawner.Portal.nWarningFX = nil
					end
					if PortalSpawner.Portal.nAmbientFX ~= nil then
						ParticleManager:DestroyParticle( PortalSpawner.Portal.nAmbientFX, false )
						PortalSpawner.Portal.nAmbientFX = nil
					end

					StopSoundOn( "Hero_AbyssalUnderlord.DarkRift.Target", PortalSpawner.Portal.hPortalEnt )	
					self.PortalSpawners[ PortalSpawner:GetSpawnerName() ] = nil
					--table.remove( self.PortalSpawners, k )
					print( "Dark Portal killed!" )
				
				else
					if PORTAL_ESCALATION_ENABLED == true then
						--local flPreviousInterval = PortalSpawner.Portal.flPortalInterval
						--print( "flPreviousInterval: " .. flPreviousInterval )

						--local flPct = 1 - ( 1 / nPortalsCountBefore )
						--print( "flPct: " .. flPct )

						PortalSpawner.Portal.flPortalInterval = PortalSpawner.Portal.flPortalInterval - PORTAL_ESCALATION_RATE
						print( "Setting new portal interval: " .. PortalSpawner.Portal.flPortalInterval )

						--local flIntervalDiff = flPreviousInterval - PortalSpawner.Portal.flPortalInterval
						PortalSpawner.Portal.flNextSpawnTime = PortalSpawner.Portal.flNextSpawnTime - PORTAL_ESCALATION_RATE
						--print( "Speeding up next spawn time by " .. flIntervalDiff )
					end
				end
			end
		end
	end
--]]
end

---------------------------------------------------------

function CMapEncounter:OnRequiredEnemyKilled( hAttacker, hVictim )
end

---------------------------------------------------------

function CMapEncounter:OnSecondaryEnemyKilled( hAttacker, hVictim )
end

---------------------------------------------------------

function CMapEncounter:OnPortalKilled( hVictim, hAttacker, nUnitCountSuppressed )
	local nCurrentValue = self:GetEncounterObjectiveProgress( "destroy_spawning_portals" )
	if nCurrentValue ~= -1 then
		self:UpdateEncounterObjective( "destroy_spawning_portals", nCurrentValue + 1, nil )
	end
end

---------------------------------------------------------
-- When portals are killed, determine the XP to drop
---------------------------------------------------------

function CMapEncounter:OnPortalV2Killed( hVictim, hAttacker, nUnitCountSuppressed )

	if hVictim == nil then
		return
	end

	if nUnitCountSuppressed > 0 then
		self:GrantRewardsForKill( hVictim, hAttacker, nUnitCountSuppressed )
	end

end

--------------------------------------------------------------------------------

-- trigger_start_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

function CMapEncounter:OnTriggerStartTouch( event )

	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	
	-- currently empty

end

--------------------------------------------------------------------------------

-- trigger_end_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

function CMapEncounter:OnTriggerEndTouch( event )
	-- currently empty
end

--------------------------------------------------------------------------------

function CMapEncounter:DropNeutralItemFromUnit( hVictim, hAttacker, bAnnounce )
	local hHero = hAttacker
	if hHero == nil or hHero:IsNull() or hHero:IsRealHero() == false then
		hHero = PlayerResource:GetSelectedHeroEntity( 0 )
	end

	if hHero == nil or hVictim == nil then
		print( "ERROR, trying to drop neutral item without a valid hero and victim" )
		return nil
	end

	local szItemDrop = GameRules.Aghanim:PrepareNeutralItemDrop( self.hRoom, false )
	if szItemDrop == nil then
		return nil
	end

	local hItem = DropNeutralItemAtPositionForHero( szItemDrop, hVictim:GetAbsOrigin(), hHero, -1, true )
	-- local newItem = CreateItem( szItemDrop, nil, nil )
	-- newItem:SetPurchaseTime( 0 )
	
	-- local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
	-- local dropTarget = hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
	-- newItem:LaunchLoot( false, 150, 0.75, dropTarget )
	

	-- if bAnnounce then
	-- 	AddFOWViewer( DOTA_TEAM_GOODGUYS, dropTarget, 300.0, 10.0, false )
	-- 	MinimapEvent( DOTA_TEAM_GOODGUYS, hVictim, dropTarget.x, dropTarget.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
	-- 	EmitSoundOn( "NeutralLootDrop.TierComplete", hVictim )
	-- 	if hAttacker and hAttacker:IsOwnedByAnyPlayer() then
	-- 		local gameEvent = {}
	-- 		gameEvent["player_id"] = hAttacker:GetPlayerID()
	-- 		gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
	-- 		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. szItemDrop
	-- 		gameEvent["message"] = "#Aghanim_FoundItem"
	-- 		FireGameEvent( "dota_combat_event_message", gameEvent )
	-- 	else	
	-- 		local gameEvent = {}
	-- 		gameEvent["player_id"] = 0 --fixme
	-- 		gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
	-- 		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. szItemDrop
	-- 		gameEvent["message"] = "#Aghanim_FoundItem"
	-- 		FireGameEvent( "dota_combat_event_message", gameEvent )
	-- 	end
	-- end

	return hItem
end

--------------------------------------------------------------------------------

function CMapEncounter:DropLifeRuneFromUnit( hVictim, hAttacker, bAnnounce )
	local newItem = CreateItem( "item_life_rune", nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( 1 )
	local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
	local dropTarget = hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 125, 175 ) )
	newItem:LaunchLoot( false, 150, 0.75, dropTarget )	
	
	if bAnnounce then
		AddFOWViewer( DOTA_TEAM_GOODGUYS, dropTarget, 300.0, 10.0, false )
		MinimapEvent( DOTA_TEAM_GOODGUYS, hVictim, dropTarget.x, dropTarget.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
		EmitSoundOn( "Rune.Bounty", hVictim )
		if hAttacker and hAttacker:IsOwnedByAnyPlayer() then

			local gameEvent = {}
			gameEvent["player_id"] = hAttacker:GetPlayerID()
			gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
			gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_life_rune"
			gameEvent["message"] = "#Aghanim_FoundLifeRune"
			FireGameEvent( "dota_combat_event_message", gameEvent )
			
		else		

			local gameEvent = {}
			gameEvent["player_id"] = 0
			gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
			gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_life_rune"
			gameEvent["message"] = "#Aghanim_FoundLifeRune"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end		
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:DropCurrencyFromUnit( hVictim, hAttacker, nPoints, bBattlePoints, bAnnounce )

	-- Suppress drop if everyone has maxed out
	if GameRules.Aghanim:CanPlayersAcceptCurrency( bBattlePoints ) == false then
		return
	end

	local newItem = nil
	if bBattlePoints == true then
		newItem = CreateItem( "item_battle_points", nil, nil )
	else
		newItem = CreateItem( "item_arcane_fragments", nil, nil )
	end

	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( nPoints )
	local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
	if bBattlePoints == true then
		drop:SetMaterialGroup( "ti10" )
	else
		drop:SetMaterialGroup( "arcane_fragment" )
	end
	local dropTarget = hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
	newItem:LaunchLoot( true, 150, 0.75, dropTarget )	
	
	-- if bAnnounce then
	-- 	AddFOWViewer( DOTA_TEAM_GOODGUYS, dropTarget, 300.0, 10.0, false )
	-- 	MinimapEvent( DOTA_TEAM_GOODGUYS, hVictim, dropTarget.x, dropTarget.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
	-- 	EmitSoundOn( "Rune.Bounty", hVictim )
	-- 	if hAttacker and hAttacker:IsOwnedByAnyPlayer() then

	-- 		local gameEvent = {}
	-- 		gameEvent["player_id"] = hAttacker:GetPlayerID()
	-- 		gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
	-- 		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_life_rune"
	-- 		gameEvent["message"] = "#Aghanim_FoundLifeRune"
	-- 		FireGameEvent( "dota_combat_event_message", gameEvent )
			
	-- 	else		

	-- 		local gameEvent = {}
	-- 		gameEvent["player_id"] = 0
	-- 		gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
	-- 		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_life_rune"
	-- 		gameEvent["message"] = "#Aghanim_FoundLifeRune"
	-- 		FireGameEvent( "dota_combat_event_message", gameEvent )
	-- 	end		
	-- end
end

--------------------------------------------------------------------------------

function CMapEncounter:DropItemFromRoomRewardContainer( hContainer, szItemName, bAnnounce )
	for szNeutralItem,v in pairs ( PRICED_ITEM_REWARD_LIST ) do
		if szNeutralItem == szItemName then
			DropNeutralItemAtPositionForHero( szItemName, hContainer:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) ), PlayerResource:GetSelectedHeroEntity( 0 ), -1, true )
			return
		end
	end

	local newItem = CreateItem( szItemName, nil, nil )
	newItem:SetPurchaseTime( 0 )
	
	local drop = CreateItemOnPositionSync( hContainer:GetAbsOrigin(), newItem )
	local dropTarget = hContainer:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
	newItem:LaunchLoot( false, 150, 0.75, dropTarget )

	if bAnnounce then
		AddFOWViewer( DOTA_TEAM_GOODGUYS, dropTarget, 300.0, 10.0, false )
		MinimapEvent( DOTA_TEAM_GOODGUYS, hContainer, dropTarget.x, dropTarget.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
		EmitSoundOn( "NeutralLootDrop.TierComplete", hContainer )

		local gameEvent = {}
		gameEvent["player_id"] = 0 --fixme
		gameEvent["teamnumber"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. szItemDrop
		gameEvent["message"] = "#Aghanim_FoundConsumableItem"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:DestroyRemainingSpawnedUnits()

	for k, hSpawner in pairs( self.Spawners ) do
		self.Spawners[k] = nil
	end

	for k, hPortalSpawner in pairs ( self.PortalSpawners ) do
		hPortalSpawner:DestroyPortal( true )
		self.PortalSpawners[k] = nil
	end

	for k,hSpawnedEnemy in pairs ( self.SpawnedEnemies ) do
		UTIL_Remove( hSpawnedEnemy )
		self.SpawnedEnemies[k] = nil
	end

	for k,hSpawnedEnemy in pairs ( self.SpawnedSecondaryEnemies ) do
		UTIL_Remove( hSpawnedEnemy )
		self.SpawnedSecondaryEnemies[k] = nil
	end

	for k, hBreakable in pairs ( self.SpawnedBreakables ) do
		UTIL_Remove( hBreakable )
		self.SpawnedBreakables[ k ] = nil
	end

	for k, hExplosiveBarrel in pairs ( self.SpawnedExplosiveBarrels ) do
		UTIL_Remove( hExplosiveBarrel )
		self.SpawnedExplosiveBarrels[ k ] = nil
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:FindEncounterEndLocator()

	local hExitLocatorList = self:GetRoom():FindAllEntitiesInRoomByName( "encounter_end_locator", false )
	if #hExitLocatorList == 0 then
		return nil
	end

	return hExitLocatorList[1]
end

--------------------------------------------------------------------------------

function CMapEncounter:SpawnEndLevelEntities()

	self.bHasSpawnedEndLevelEntities = true

	local vExitTemplate = Entities:FindByName( nil, "encounter_end_template" )
	if vExitTemplate == nil then
		print( "Unable to find encounter_end_template\n" )
		return
	end

	local hExitLocator = self:FindEncounterEndLocator()
	if hExitLocator == nil then
		return
	end

	local vExitLocation = hExitLocator:GetAbsOrigin()
	local vSpawnLocation = Vector( vExitLocation.x, vExitLocation.y, GetGroundHeight( vExitLocation, nil ) )
	vExitTemplate:SetAbsOrigin( vSpawnLocation )
	vExitTemplate:ForceSpawn()

	--meh
	local nDepth = self.hRoom:GetDepth() 
	
	for _,hTemplateEnt in pairs ( vExitTemplate:GetSpawnedEntities() ) do
		if hTemplateEnt:GetName() == "room_reward_spawn" then
			self.vRoomRewardCratePos = hTemplateEnt:GetAbsOrigin()
		end
		if nDepth == 6 or nDepth == 11 or nDepth == 13 or nDepth == 17 then  
			if hTemplateEnt:GetName() == "shop" or hTemplateEnt:GetName() == "shop_trigger" or hTemplateEnt:GetName() == "shop_obstruction" or hTemplateEnt:GetName() == "shop_particles"  or hTemplateEnt:GetName() == "neutral_stash" then
				UTIL_Remove( hTemplateEnt )
			end
		end
	end

	if self.hRoom:HasCrystal() then
		local hCrystal = CreateUnitByName( "npc_dota_story_crystal", self.vRoomRewardCratePos + Vector( 0, 350, 0 ), true, nil, nil, DOTA_TEAM_GOODGUYS )
		if hCrystal ~= nil then
			print( "spawned story crystal" )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:ResetHeroState()
	for nPlayerID = 0,AGHANIM_PLAYERS-1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			if HEAL_ON_ENCOUNTER_COMPLETE then
				if not hPlayerHero:IsAlive() then
					local vLocation = hPlayerHero:GetOrigin()
					if self.hRoom:GetType() == ROOM_TYPE_TRAPS then
						local hExitLocator = self:FindEncounterEndLocator()
						if hExitLocator == nil then
							return
						else
							vLocation = hExitLocator:GetAbsOrigin()
						end
					end

					hPlayerHero:RespawnHero( false, false )
					FindClearSpaceForUnit( hPlayerHero, vLocation, true )
					CenterCameraOnUnit( nPlayerID, hPlayerHero )
				end

				-- make the players invulnerable for a few seconds after winning - just generally protecting them from stuff that might be lingering in the room
				hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_invulnerable", { duration = 5 } )

				--				   PositiveBuffs, NegativeBuffs, FrameOnly, RemoveStuns, RemoveExceptions
				hPlayerHero:Purge( false,		  true,			 false,		true,		 false )
		
				hPlayerHero:SetHealth( hPlayerHero:GetMaxHealth() )
				hPlayerHero:SetMana( hPlayerHero:GetMaxMana() )
			end

			for i = 0,DOTA_MAX_ABILITIES-1 do
				local hAbility = hPlayerHero:GetAbilityByIndex( i )
				if hAbility and hAbility:IsRefreshable() then
					hAbility:SetFrozenCooldown( false )
					hAbility:EndCooldown()
					hAbility:RefreshCharges()
				end
			end

			--for j = 0,DOTA_ITEM_INVENTORY_SIZE-1 do
			local j = DOTA_ITEM_TP_SCROLL
				local hItem = hPlayerHero:GetItemInSlot( j )
				if hItem then
					if hItem:GetAbilityName() == "item_bottle" then
						local nMaxCharges = hItem:GetSpecialValueFor( "max_charges" )
						--print( "filling bottle: current charges = " .. hItem:GetCurrentCharges() .. ". Max Charges = " .. nMaxCharges .. ". Restoring up to " .. AGHANIM_ENCOUNTER_BOTTLE_CHARGES )
						hItem:SetCurrentCharges( math.min( hItem:GetCurrentCharges() + AGHANIM_ENCOUNTER_BOTTLE_CHARGES, nMaxCharges ) )
					elseif hItem:IsRefreshable()  then
						hItem:SetFrozenCooldown( false )
						hItem:EndCooldown()
					end
				end
			--end

			local hNeutralItem = hPlayerHero:GetItemInSlot( DOTA_ITEM_NEUTRAL_SLOT )
			if hNeutralItem and hNeutralItem:IsRefreshable() then
				hNeutralItem:SetFrozenCooldown( false )
				hNeutralItem:EndCooldown()
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, hPlayerHero )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			-- Hack to cap Big Game Hunter gains per encounter
			if hPlayerHero:GetUnitName() == "npc_dota_hero_sniper" then
				printf( "Limiter - looking at Sniper hPlayerHero" )
				local hBigGameHunterAbility = hPlayerHero:FindAbilityByName( "aghsfort_special_sniper_assassinate_killshot" )
				if hBigGameHunterAbility ~= nil and hBigGameHunterAbility:GetLevel() > 0 then
					printf( "found Big Game Hunter ability" )
					local hLimiterBuff = hPlayerHero:FindModifierByName( "modifier_sniper_big_game_hunter_limiter" )
					if hLimiterBuff == nil then
						hLimiterBuff = hPlayerHero:AddNewModifier( hPlayerHero, hBigGameHunterAbility, "modifier_sniper_big_game_hunter_limiter", { duration = -1 } )
					end
					local nStacks = hBigGameHunterAbility:GetSpecialValueFor( "value2" )
					--printf( "reset limiter buff to %d stacks," nStacks )
					hLimiterBuff:SetStackCount( nStacks )
				end
			end
		end	
	end
end

--------------------------------------------------------------------------------

function CMapEncounter:AddRewardItemsToCrate( hRewardCrate, bDebug )

	local bHardRoom = ( self.hRoom:GetEliteRank() > 0 )
	if self.hRoom:GetRoomChoiceReward() == "REWARD_TYPE_EXTRA_LIVES" then
		if bDebug == true then
			return
		end

		local nNumLives = 2
		if bHardRoom then
			nNumLives = 4
		end
		for i=1,nNumLives do
			table.insert( hRewardCrate.RoomReward, "item_life_rune" )
		end
	end

	if self.hRoom:GetRoomChoiceReward() == "REWARD_TYPE_GOLD" then
		if bDebug == true then
			-- Can't do this here since it'll drop at the final depth value
			return
		end
		for i=1,AGHANIM_PLAYERS do 
			table.insert( hRewardCrate.RoomReward, "item_bag_of_gold" )
		end
	end

	if self.hRoom:GetRoomChoiceReward() == "REWARD_TYPE_TREASURE" then
		local nTier = 1
		if bHardRoom then
			nTier = 2
		end

		table.insert( hRewardCrate.RoomReward, "item_tome_of_greater_knowledge" )

		for nItem=1,nTier do
			local szItemName = GameRules.Aghanim:PrepareNeutralItemDrop( self.hRoom, bHardRoom )
			if szItemName ~= nil then 
				table.insert( hRewardCrate.RoomReward, szItemName )
			end
		end

		local vecItems = TREASURE_REWARDS[ nTier ]
		for i = 1, NUM_CONSUMABLES_FROM_ROOM_REWARD do
			table.insert( hRewardCrate.RoomReward, vecItems[ self:RoomRandomInt( 1, #vecItems ) ] )
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:CreateRewardCrate()

	if self.hRoom:GetRoomChoiceReward() == nil or self.nGoldReward == 0 then
		return
	end

	local hDebugRoom = GameRules.Aghanim:GetTestEncounterDebugRoom()
	if hDebugRoom ~= nil then
		self:AddRewardItemsToCrate( GameRules.Aghanim.debugItemsToStuffInCrate, true )
	end		

	local hRewardCrate = CreateUnitByName( "npc_treasure_chest", self.vRoomRewardCratePos, true, nil, nil, DOTA_TEAM_GOODGUYS )
	if hRewardCrate == nil then
		return
	end

	hRewardCrate:SetAbsAngles( 0, 270, 0 )
	hRewardCrate.CommonItems = {}
	hRewardCrate.fCommonItemChance = 0.0
	hRewardCrate.RareItems = {}
	hRewardCrate.fRareItemChance = {}
	hRewardCrate.nMinGold = 0
	hRewardCrate.nMaxGold = 0
	hRewardCrate.fGoldChance = 0
	if bHardRoom then
		hRewardCrate:SetModelScale( 4.0 )
	else
		hRewardCrate:SetModelScale( 2.0 )
	end
	hRewardCrate.Encounter = self
	hRewardCrate.RoomReward = {}
	hRewardCrate.nDepth = self.hRoom:GetDepth()
	hRewardCrate.nEliteRank = self.hRoom:GetEliteRank()

	if self.hRoom:GetType() == ROOM_TYPE_ENEMY then
		local nNumItemsToDrop = self.nNumItemsToDrop
		if ( nNumItemsToDrop == 0 ) and hDebugRoom ~= nil then
			-- Must do this here because when debugging, we don't actually start encounters we skip
			nNumItemsToDrop = GameRules.Aghanim:RollRandomNeutralItemDrops()
		end

		if nNumItemsToDrop > 0 then
			for i=1,nNumItemsToDrop do
				local szItemName = GameRules.Aghanim:PrepareNeutralItemDrop( self.hRoom, false )
				if szItemName ~= nil then
					print( "adding " .. szItemName .. " to reward crate" )  
					table.insert( hRewardCrate.RoomReward, szItemName )
				end
			end
		end

		-- Spawn any un-dropped BPs
		if self.nNumBPToDrop > 0 then
			for i=1,self.nNumBPToDrop do
				self:DropCurrencyFromUnit( hRewardCrate, hRewardCrate, RandomInt( BATTLE_POINT_MIN_DROP_VALUE, BATTLE_POINT_MAX_DROP_VALUE ), true, false )
			end
		end
	end

	-- NOTE: This must happen *after* RollRandomNeutralItemDrops above to ensure reproduceability of neutral drops
	-- Basically, all rolls related to neutral drops must occur between encounter Start + now [with no other rolls for anything else]
	-- Then we can do more rolls for neutral items to be placed in the treasure
	self:AddRewardItemsToCrate( hRewardCrate, false )

	if self.hRoom:GetType() == ROOM_TYPE_ENEMY or self.hRoom:GetType() == ROOM_TYPE_TRAPS then
		-- Spawn any un-dropped Arcance Fragments
		if self.nNumFragmentsToDrop > 0 then
			print( "WARNING! Number of random Arcane Fragment Drops is not 0 at the end of the round!  Dropping at exit locator. This is ok for TRAP ROOMS!" )
			for i=1,self.nNumFragmentsToDrop do
				self:DropCurrencyFromUnit( hRewardCrate, hRewardCrate, self:GetArcaneFragmentDropValue(), false, false )
			end
		end
	end

	-- Stuff items we would have dropped during winning encounters into this crate
	if GameRules.Aghanim:GetTestEncounterDebugRoom() == nil and GameRules.Aghanim.debugItemsToStuffInCrate ~= nil then
		for i = 1,#GameRules.Aghanim.debugItemsToStuffInCrate.RoomReward do
			print( GameRules.Aghanim.debugItemsToStuffInCrate.RoomReward[i] )
			table.insert( hRewardCrate.RoomReward, GameRules.Aghanim.debugItemsToStuffInCrate.RoomReward[i] )
		end
		GameRules.Aghanim.debugItemsToStuffInCrate = nil
	end

end

--------------------------------------------------------------------------------

function CMapEncounter:GetArcaneFragmentDropValue()
	local fPoints = ENCOUNTER_DEPTH_ARCANE_FRAGMENTS[ self.hRoom:GetDepth() ]
	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - base value: ' .. fPoints )

	local fDropEV = GameRules.Aghanim:GetFragmentDropEV()
	fPoints = fPoints / fDropEV
	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - modified by drop EV to ' .. fPoints )

	local fMultiplier = ARCANE_FRAGMENT_DIFFICULTY_MODIFIERS[ GameRules.Aghanim:GetAscensionLevel() + 1 ]
	fPoints = fPoints * fMultiplier
	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - modified by Ascension multiplier: ' .. fMultiplier .. '. result is: ' .. fPoints )

	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - adding variance +/-: ' .. ARCANE_FRAGMENT_DROP_VALUE_VARIANCE )

	local fLow = fPoints - (fPoints * ARCANE_FRAGMENT_DROP_VALUE_VARIANCE)
	local fHigh = fPoints + (fPoints * ARCANE_FRAGMENT_DROP_VALUE_VARIANCE)
	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - adding variance between: ' .. fLow .. ' and: ' .. fHigh )

	fPoints = RandomFloat( fLow, fHigh )
	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - rolled ' .. fPoints )	

	fPoints = math.ceil( fPoints * ARCANE_FRAGMENT_DROP_VALUE )
	--print( 'CMapEncounter:GetArcaneFragmentDropValue() - trimmed down by drop EV: ' .. ARCANE_FRAGMENT_DROP_VALUE .. ' and rounded to: ' .. fPoints )

	return fPoints
end

--------------------------------------------------------------------------------

function CMapEncounter:GenerateRewards()
	
	if self.bHasGeneratedRewards == true then
		return
	end

	local bHardRoom = ( self.hRoom:GetEliteRank() > 0 ) or ( self.hRoom:GetType() == ROOM_TYPE_TRAPS )

	local nBPReward = ENCOUNTER_DEPTH_BATTLE_POINTS[ self.hRoom:GetDepth() ]
	nBPReward = nBPReward * BATTLE_POINT_DIFFICULTY_MODIFIERS[ GameRules.Aghanim:GetAscensionLevel() + 1 ]

	local nArcaneFragmentsReward = ENCOUNTER_DEPTH_ARCANE_FRAGMENTS[ self.hRoom:GetDepth() ]

	--print( 'CMapEncounter:GenerateRewards() - base Arcane Fragment reward: ' .. nArcaneFragmentsReward )

	-- only reward a percentage of the points since the rest is given as drops
	if self.hRoom:GetType() == ROOM_TYPE_ENEMY or self.hRoom:GetType() == ROOM_TYPE_TRAPS then
		nArcaneFragmentsReward = nArcaneFragmentsReward * ARCANE_FRAGMENT_ROOM_CLEAR_VALUE
		--print( 'CMapEncounter:GenerateRewards() - reducing room clear reward to: ' .. nArcaneFragmentsReward )
	end
	
	-- scale the reward by the difficulty of the run.
	local fMultiplier = ARCANE_FRAGMENT_DIFFICULTY_MODIFIERS[ GameRules.Aghanim:GetAscensionLevel() + 1 ]
	nArcaneFragmentsReward = nArcaneFragmentsReward * fMultiplier
	--print( 'CMapEncounter:GenerateRewards() - Arcane Fragment reward increased by ' .. fMultiplier .. ' for Ascension. new reward: ' .. nArcaneFragmentsReward )
	nArcaneFragmentsReward = math.ceil( nArcaneFragmentsReward )
	--print( 'CMapEncounter:GenerateRewards() - Arcane Fragment reward rounded up to ' .. nArcaneFragmentsReward )

	local vecBPRewards = {}
	if nBPReward > 0 then
		vecBPRewards = GameRules.Aghanim:GrantAllPlayersPoints( nBPReward, true, "completing " .. self.szEncounterName .. " at depth " ..  tostring( self.hRoom:GetDepth() ) )
	end

	local vecArcaneFragmentRewards = {}
	if nArcaneFragmentsReward > 0 then
		vecArcaneFragmentRewards = GameRules.Aghanim:GrantAllPlayersPoints( nArcaneFragmentsReward, false, "completing " .. self.szEncounterName .. " at depth " ..  tostring( self.hRoom:GetDepth() ) )
	end

	self:CreateRewardCrate()

	local RewardOptions = {}
	CustomNetTables:SetTableValue( "reward_options", "current_depth", { tostring(self.hRoom:GetDepth()) } )

	-- certain abilities (like auras) we want to prevent being rolled more than once by the party as a whole
	local vecAbilityNamesToExclude = {}

	local nXPReward = self.nXPReward + self.nRemainingXPFromEnemies
	local nGoldReward = self.nGoldReward + self.nRemainingGoldFromEnemies

	for nPlayerID = 0,AGHANIM_PLAYERS-1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then	
			hPlayerHero:AddExperience( nXPReward, DOTA_ModifyXP_Unspecified, false, true )
			PlayerResource:ModifyGold( nPlayerID, nGoldReward, true, DOTA_ModifyGold_Unspecified )
		end

		for _,szAbilityName in pairs( GetPlayerAbilitiesAndItems( nPlayerID ) ) do
			if string.match( szAbilityName, "aghsfort_aura" ) or string.match( szAbilityName, "aghsfort_tempbuff" ) then
				table.insert( vecAbilityNamesToExclude, szAbilityName )
			end
		end
	end
	
	for nPlayerID = 0,AGHANIM_PLAYERS-1 do
		local vecPlayerRewards = GetRoomRewards( self.hRoom:GetDepth(), self.hRoom:GetType(), bHardRoom, nPlayerID, vecAbilityNamesToExclude )
		RewardOptions[ tostring(nPlayerID) ] = vecPlayerRewards;
		--print( "CMapEncounter:GenerateRewards - Sending rewards to player id " .. nPlayerID .. " for encounter " .. self.szEncounterName )
		--DeepPrintTable( vecPlayerRewards )
	end


	-- figure out the overall rarity of the rewards for the main block of the reward panel
	local szRarity = "common"
	if bHardRoom then
		szRarity = "elite"
	end
	if self.hRoom:GetType() == ROOM_TYPE_BOSS or self.hRoom:GetDepth() == 1 then
		szRarity = "epic"
	end

	if TableLength(RewardOptions) > 0  then	
		RewardOptions[ "battle_points" ] = vecBPRewards
		RewardOptions[ "arcane_fragments" ] = vecArcaneFragmentRewards
		RewardOptions[ "xp" ] = nXPReward
		RewardOptions[ "gold" ] = nGoldReward
		RewardOptions[ "rarity" ] = szRarity

		--printf("sending reward options")
		--DeepPrintTable( RewardOptions )		
		CustomNetTables:SetTableValue( "reward_options", tostring(self.hRoom:GetDepth()), RewardOptions )
	end
	
	self.bHasGeneratedRewards = true
end

--------------------------------------------------------------------------------

function CMapEncounter:HasStarted()
	return self.flStartTime ~= -1 
end

--------------------------------------------------------------------------------

function CMapEncounter:GetStartTime()
	return self.flStartTime
end

--------------------------------------------------------------------------------

function CMapEncounter:GetRoom()
	return self.hRoom
end

--------------------------------------------------------------------------------

function CMapEncounter:GetSpawners()
	return self.Spawners
end

--------------------------------------------------------------------------------

function CMapEncounter:GetPortalSpawners()
	return self.PortalSpawners
end


--------------------------------------------------------------------------------

function CMapEncounter:GetRemainingPortalCount()

	local nPortals = 0

	if self.PortalSpawners ~= nil then
		for _,hPortalSpawner in pairs ( self.PortalSpawners ) do
			if hPortalSpawner and hPortalSpawner:IsDestroyed() == false then
				nPortals = nPortals + 1
			end
		end
	end

	if self.PortalSpawnersV2 ~= nil then
		for _,hPortalSpawner in pairs ( self.PortalSpawnersV2 ) do
			if hPortalSpawner ~= nil then
				nPortals = nPortals + hPortalSpawner:GetPortalUnitCount()
			end
		end
	end

	return nPortals
end

--------------------------------------------------------------------------------

function CMapEncounter:HasAnyPortals()
	return self:GetRemainingPortalCount() > 0
end

--------------------------------------------------------------------------------

function CMapEncounter:GetSpawner( szSpawnerName )
	return self.Spawners[szSpawnerName]
end

--------------------------------------------------------------------------------

function CMapEncounter:GetPortalSpawner( szSpawnerName )
	return self.PortalSpawners[szSpawnerName]
end

--------------------------------------------------------------------------------

function CMapEncounter:GetPortalSpawnerV2( szSpawnerName )
	return self.PortalSpawnersV2[szSpawnerName]
end

--------------------------------------------------------------------------------

function CMapEncounter:GetDepth()
	return self.hRoom:GetDepth()
end

--------------------------------------------------------------------------------

function CMapEncounter:GetTotalGoldRewardPerPlayer()
	return ENCOUNTER_DEPTH_GOLD_REWARD[self:GetDepth()]
end

--------------------------------------------------------------------------------

function CMapEncounter:GetTotalXPRewardPerPlayer()
	return ENCOUNTER_DEPTH_XP_REWARD[self:GetDepth()]
end

--------------------------------------------------------------------------------
-- If this is true, the gold and XP rewards from killing an enemy will be 
-- distrubuted evenly amongst the total enemy count.  If false, use the
-- values from the unit data.
--------------------------------------------------------------------------------

function CMapEncounter:SetCalculateRewardsFromUnitCount( bCalculate )
	self.bCalculateRewardsFromUnitCount = bCalculate
end

--------------------------------------------------------------------------------

function CMapEncounter:GetPreviewUnit()
	return nil
end

--------------------------------------------------------------------------------

function CMapEncounter:GetName()
	return self.szEncounterName
end

--------------------------------------------------------------------------------

function CMapEncounter:GetRetreatPoints()
	return self.RetreatPoints
end

----------------------------------------------------------------------

function CMapEncounter:HasRemainingEnemies()
	return #self.SpawnedEnemies > 0
end

----------------------------------------------------------------------

function CMapEncounter:GetSpawnedUnits()
	return self.SpawnedEnemies
end

---------------------------------------------------------

function CMapEncounter:GetSpawnedSecondaryUnits()
	return self.SpawnedSecondaryEnemies
end

---------------------------------------------------------

function CMapEncounter:GetSpawnedUnitsOfType( szUnitName )

	local hUnits = {}

	for i=1,#self.SpawnedEnemies do

		if self.SpawnedEnemies[i] ~= nil and self.SpawnedEnemies[i]:GetUnitName() == szUnitName then
			table.insert( hUnits, self.SpawnedEnemies[i] )
		end

	end

	return hUnits
end

--------------------------------------------------------------------------------

function CMapEncounter:Dev_ForceCompleteEncounter()
	self.bDevForceCompleted = true
end

--------------------------------------------------------------------------------

function CMapEncounter:GetAghanimSummon()
	return self:GetPreviewUnit()
end

--------------------------------------------------------------------------------

function CMapEncounter:SetupBristlebackShop( bRepopulateNeutralItems )
	if bRepopulateNeutralItems then
		local vecPricedItems1 = GetPricedNeutralItems( self.hRoom:GetDepth() - 1, false )
		local vecPricedItems2 = GetPricedNeutralItems( self.hRoom:GetDepth() - 2, false )

		for _,szLessItem in pairs ( vecPricedItems1 ) do
			local bFound = false
			for _,szThisDepthItem in pairs ( vecPricedItems2 ) do
				if szThisDepthItem == szLessItem then
					bFound = true
					break
				end
			end

			if not bFound then
				table.insert( vecPricedItems2, szLessItem )
			end
		end 

		local vecFilteredItems = GameRules.Aghanim:FilterPreviouslyDroppedItems( vecPricedItems1 )
		
		for nItem = #GameRules.Aghanim.BristlebackItems,1,-1 do
			local szPreviousItemName = GameRules.Aghanim.BristlebackItems[ nItem ]
			GameRules:GetGameModeEntity():RemoveItemFromCustomShop( szPreviousItemName, "boss_shop" )
		end

		for i=1,8 do 
			local index = self:RoomRandomInt( 1, #vecFilteredItems )
			local szItemName = vecFilteredItems[ index ]
			GameRules:GetGameModeEntity():AddItemToCustomShop( szItemName, "boss_shop", "2" )
			table.remove( vecFilteredItems, index )

			table.insert( GameRules.Aghanim.BristlebackItems, szItemName )
			GameRules.Aghanim:MarkNeutralItemAsDropped( szItemName )
		end

		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do 
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero then
				local PurchasableShards = PURCHASABLE_SHARDS[ hPlayerHero:GetUnitName() ]
				if PurchasableShards then
					local PossibleShards = shallowcopy( PurchasableShards )
					local nRemainingShards = 3
					while nRemainingShards > 0 do
						local nShardIndex = self:RoomRandomInt( 1, #PossibleShards )
						local szShardName = PossibleShards[ nShardIndex ]
						if szShardName then
							GameRules:GetGameModeEntity():AddItemToCustomShop( szShardName, "boss_shop", hPlayerHero:GetUnitName() )
							GameRules:IncreaseItemStock( DOTA_TEAM_GOODGUYS, szShardName, 1, -1 )
							table.remove( PossibleShards, nShardIndex )
							table.insert( GameRules.Aghanim.BristlebackItems, szShardName )
						end

						nRemainingShards = nRemainingShards - 1
					end
				end 
			end
		end
	end

	GameRules:IncreaseItemStock( DOTA_TEAM_GOODGUYS, "item_life_rune", AGHANIM_PLAYERS, -1 )
	GameRules:IncreaseItemStock( DOTA_TEAM_GOODGUYS, "item_book_of_strength", AGHANIM_PLAYERS, -1 )
	GameRules:IncreaseItemStock( DOTA_TEAM_GOODGUYS, "item_book_of_agility", AGHANIM_PLAYERS, -1 )
	GameRules:IncreaseItemStock( DOTA_TEAM_GOODGUYS, "item_book_of_intelligence", AGHANIM_PLAYERS, -1 )

	local hBristleEnts = self:GetRoom():FindAllEntitiesInRoomByName( "boss_shop" )
	for _,hEnt in pairs ( hBristleEnts ) do
		if hEnt:GetClassname() == "ent_dota_shop" then
			local szWearables =
			{
				"models/heroes/bristleback/bristleback_back.vmdl",
				"models/heroes/bristleback/bristleback_bracer.vmdl",
				"models/heroes/bristleback/bristleback_head.vmdl", 
				"models/heroes/bristleback/bristleback_necklace.vmdl", 
			}
			
			for _,szWearable in pairs ( szWearables ) do
				local hWearable = Entities:CreateByClassname( "wearable_item" )
				if hWearable ~= nil then
					hWearable:SetModel( szWearable )
					hWearable:SetTeam( DOTA_TEAM_GOODGUYS )
					hWearable:SetOwner( hEnt )
					hWearable:FollowEntity( hEnt, true )
				end
			end 			
		end
	end
end

return CMapEncounter
