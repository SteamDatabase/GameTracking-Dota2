
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_CryptGate == nil then
	CMapEncounter_CryptGate = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )
	
	self:SetCalculateRewardsFromUnitCount( true )

	self.vecSkeletonPortals = {}
	table.insert( self.vecSkeletonPortals, self:AddSpawner( CDotaSpawner("spawner_skeletons_sw", "spawner_skeletons_sw",
		{
			{
				EntityName = "npc_dota_crypt_gate_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		}
	) ) )

	table.insert( self.vecSkeletonPortals, self:AddSpawner( CDotaSpawner( "spawner_skeletons_se", "spawner_skeletons_se", 
		{
			{
				EntityName = "npc_dota_crypt_gate_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		}
	) ) )

	table.insert( self.vecSkeletonPortals, self:AddSpawner( CDotaSpawner( "spawner_skeletons_nw", "spawner_skeletons_nw",
		{
			{
				EntityName = "npc_dota_crypt_gate_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		}
	) ) )

	table.insert( self.vecSkeletonPortals, self:AddSpawner( CDotaSpawner( "spawner_skeletons_ne", "spawner_skeletons_ne",
		{
			{
				EntityName = "npc_dota_crypt_gate_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		}
	) ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_crypt_bone_giant", "spawner_crypt_bone_giant", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_crypt_bone_giant",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true
	) )

	self.nTotalSkeletonsSpawned = 0
	self.nPhase2Giants = 1
	self.nPhase3Giants = 2
	self.nPhase4Giants = 3
end


--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:GetMaxSpawnedUnitCount()
	local nGiants = self.nPhase2Giants + self.nPhase3Giants + self.nPhase4Giants
	return nGiants + self.nTotalSkeletonsSpawned
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:OnThink()
	CMapEncounter.OnThink( self )

	if not self.bCreatureSpawnsActivated then 
		return
	end

	if GameRules:IsGamePaused() == true then
		return
	end 

	local flTotalAccumulatedTime = 0
	local netTable = {}

	local nNumComplete = 0
	for _,Trigger in pairs ( self.GateTriggers ) do
		local TriggerData = {}
		TriggerData[ "touched" ] = 0
		TriggerData[ "complete" ] = 0
		TriggerData[ "X" ] = Trigger:GetAbsOrigin().x
		TriggerData[ "Y" ] = Trigger:GetAbsOrigin().y
		TriggerData[ "Z" ] = Trigger:GetAbsOrigin().z

		if Trigger.bTouched then 
			TriggerData[ "touched" ] = 1
			Trigger.flAccumulatedTime = math.min( self.flTimeThreshold, Trigger.flAccumulatedTime + AGHANIM_THINK_INTERVAL )
		end

		flTotalAccumulatedTime = flTotalAccumulatedTime + Trigger.flAccumulatedTime
		TriggerData[ "progress" ] = Trigger.flAccumulatedTime / self.flTimeThreshold
		if TriggerData[ "progress" ] >= 1.0 then 
			nNumComplete = nNumComplete + 1 
		end

		netTable[ Trigger:GetName() ] = TriggerData	
	end

	self:UpdateEncounterObjective( "objective_crypt_gate_stand_on_switches", nNumComplete, 4 )

	local flTotalProgress = flTotalAccumulatedTime / self.flTotalTimeThreshold

	netTable[ "total_progress" ] = flTotalProgress
	--print( "total progress:" .. flTotalProgress .. " " .. flTotalAccumulatedTime .. " of " .. self.flTotalTimeThreshold )
	CustomNetTables:SetTableValue( "encounter_state", "crypt_gate", netTable )

	local hBoneGiant = self:GetPortalSpawnerV2( "spawner_crypt_bone_giant" )
	if self.nPhase == 1 and flTotalProgress >= 0.25 then 
		self.nPhase = 2 
		--print( "spawning 1 bone giant" )
		hBoneGiant:SpawnUnitsFromRandomSpawners( self.nPhase2Giants )
	end

	if self.nPhase == 2 and flTotalProgress >= 0.5 then
		self.nPhase = 3 
		--print( "spawning 2 bone giant" )
		hBoneGiant:SpawnUnitsFromRandomSpawners( self.nPhase3Giants )
	end

	if self.nPhase == 3 and flTotalProgress >= 0.75 then
		self.nPhase = 4
		--print( "spawning 3 bone giant" )
		hBoneGiant:SpawnUnitsFromRandomSpawners( self.nPhase4Giants )
	end

	if self.nPhase == 4 and flTotalProgress >= 1.0 then 
		self.nPhase = 5 
		self:OpenGate()
	end

	if self.nPhase < 5 and GameRules:GetGameTime() > self.flNextSpawnTime then 
		self.flNextSpawnTime = self.flNextSpawnTime + self.flInterval
		self.flInterval = math.max( self.flIntervalMinimum, self.flInterval - self.flIntervalStep )

		
		if #self.SpawnedEnemies > self.nMaxSkeletons then 
			print( "too many skeletons, skipping spawn")
			return
		end

		for _,hSkeletonPortal in pairs ( self.vecSkeletonPortals ) do 
			local vecSkeletons = hSkeletonPortal:SpawnUnits()
			if #vecSkeletons > 0 then 
				self.nTotalSkeletonsSpawned = self.nTotalSkeletonsSpawned + #vecSkeletons 
			end
		end

		local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), 5000.0 )

		if #heroes > 0 then 
			for _,hEnemy in pairs ( self.SpawnedEnemies ) do
					
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hEnemy:GetUnitName(), hero:GetUnitName() )
					hEnemy:SetInitialGoalEntity( hero )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	printf( "Start Touch: szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if hUnit and hUnit:IsRealHero() and hTriggerEntity and 
		( szTriggerName == "crypt_door_trigger_w" or 
			szTriggerName == "crypt_door_trigger_e" or 
			szTriggerName == "crypt_door_trigger_s" or 
			szTriggerName == "crypt_door_trigger_n" ) then

		hTriggerEntity.bTouched = true 
			
		if self.bCreatureSpawnsActivated == nil then 
			self.bCreatureSpawnsActivated = true
			self.flNextSpawnTime = GameRules:GetGameTime()

			printf( "Unit \"%s\" triggered creature spawning!", hUnit:GetUnitName() )
	   		EmitGlobalSound( "RoundStart" )
	   	end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:OnTriggerEndTouch( event )
	CMapEncounter.OnTriggerEndTouch( self, event )

	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	printf( "End Touch: szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if hUnit and hUnit:IsRealHero() and hTriggerEntity and 
	( szTriggerName == "crypt_door_trigger_w" or 
		szTriggerName == "crypt_door_trigger_e" or 
		szTriggerName == "crypt_door_trigger_s" or 
		szTriggerName == "crypt_door_trigger_n" ) then

		local bAnyTouching = false 
		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
			if hPlayerHero then 
				if hTriggerEntity:IsTouching( hPlayerHero ) then 
					bAnyTouching = true
					return 
				end
			end
		end

		hTriggerEntity.bTouched = bAnyTouching 
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:GetPreviewUnit()
	return "npc_dota_crypt_gate_skeleton"
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.flNextSpawnTime = 99999999.0
	self.flInterval = 5.0
	self.flIntervalStep = 0.25
	self.flIntervalMinimum = 3.0
	self.flTimeThreshold = 30.0

	self.nPhase = 1

	self.GateTriggers = {}
	local WestTrigger = self:GetRoom():FindAllEntitiesInRoomByName( "crypt_door_trigger_w", true )
	local EastTrigger = self:GetRoom():FindAllEntitiesInRoomByName( "crypt_door_trigger_e", true )
	local SouthTrigger = self:GetRoom():FindAllEntitiesInRoomByName( "crypt_door_trigger_s", true )
	local NorthTrigger = self:GetRoom():FindAllEntitiesInRoomByName( "crypt_door_trigger_n", true )
	table.insert( self.GateTriggers, WestTrigger[1] )
	table.insert( self.GateTriggers, EastTrigger[1] )
	table.insert( self.GateTriggers, SouthTrigger[1] )
	table.insert( self.GateTriggers, NorthTrigger[1] )


	for _,Trigger in pairs ( self.GateTriggers ) do
		Trigger.flAccumulatedTime = 0
	end

	self.flTotalTimeThreshold = #self.GateTriggers * self.flTimeThreshold

	self.nMaxSkeletons = 40
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:InitializeObjectives()
	self:AddEncounterObjective( "objective_crypt_gate_stand_on_switches", 0, 4 )

	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:CheckForCompletion()
	if self.nPhase == 5 and self:HasRemainingEnemies() == false then 
		self:OpenGate()
		return true 
	end

	return false 
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:OnComplete()
	CMapEncounter.OnComplete( self )

	self:OpenGate()
end

--------------------------------------------------------------------------------

function CMapEncounter_CryptGate:OpenGate()
	print("Opening Gate!")
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "crypt_holdout_exit_door_relay", false )
	if hRelays then
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
			EmitGlobalSound( "Dungeon.StoneGate" )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_CryptGate
