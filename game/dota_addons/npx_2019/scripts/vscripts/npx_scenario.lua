
if CDotaNPXScenario == nil then
	CDotaNPXScenario = class({})
end

require( "spawner" )
require( "npx_scenario_hints" )

----------------------------------------------------------------------------

function CDotaNPXScenario:constructor( szScenario )
	self:InitScenarioKeys()
	if self.hScenario == nil then
		print( "CDotaNPXScenario:constructor - ERROR! Scenario " .. szScenario .. " not found!" )
		return
	end

	self.szScenarioName = szScenario
	self.QueryInfos = {}
	self.Attempts = {}
	self.Tasks = {}
	self.ReactiveHints = {}
	self.WorldTextHints = {}
	self.Dialogs = {}
	self.nScenarioRank = 0
	self.nMaxScenarioRank = 0
	self.PendingNPCSpawnsFuncs = {}
	self.PrecachedNPCs = {}
	self.hSpawnedNPCs = {}
	self.hScenarioNPCSpawnGroups = {}
	self.bStarted = false
	self.bPlayerHeroReady = false
	self.rgSpawners = {}
	self.rgScheduledFunctions = {}
	self.hPlayerHero = nil
	self.HintNPCs = {}
	self.bIntroductionComplete = false
	self.nUIHintID = 0
	self.nCurrentUIHintID = -1
end

----------------------------------------------------------------------------
-- Override this function in your scenario class
----------------------------------------------------------------------------
function CDotaNPXScenario:InitScenarioKeys()
	self.hScenario = nil
end

----------------------------------------------------------------------------

function CDotaNPXScenario:SetupScenario()
	if self.hScenario.DaynightCycleDisabled ~= nil then
		GameRules:GetGameModeEntity():SetDaynightCycleDisabled( self.hScenario.DaynightCycleDisabled )
		GameRules:SetTimeOfDay( 0.251 )
	end
	SendToConsole( "dota_enable_new_player_shop 1" )
	GameRules:SetPreGameTime( self.hScenario.PreGameTime )
	GameRules:SetHeroSelectionTime( self.hScenario.HeroSelectionTime )
	GameRules:SetStrategyTime( self.hScenario.StrategyTime )

	PlayerResource:SetCustomTeamAssignment( 0, self.hScenario.Team )
	
	if self.hScenario.ForceHero then
		GameRules:GetGameModeEntity():SetCustomGameForceHero( self.hScenario.ForceHero )
	end

	self:PrecacheResources()

	if not self:SetupNPCs() then
		return false
	end

	if not self:SetupTasks() then
		return false
	end

	return true
end

----------------------------------------------------------------------------

function CDotaNPXScenario:PrecacheResources()
end

----------------------------------------------------------------------------

function CDotaNPXScenario:SetupNPCs()
	print( "...setting up NPCs..." )
	if self.hScenario.Spawners == nil then
		return true
	end

	for _,Spawner in pairs ( self.hScenario.Spawners ) do
		self:AddSpawner( CDotaSpawner( Spawner.SpawnerName, Spawner.NPCs, self, Spawner.SpawnOnPrecacheComplete ) )
	end

	return true
end

----------------------------------------------------------------------------

function CDotaNPXScenario:BuildQueries()
	for k,v in pairs( self.hScenario.Queries ) do
		local hQueryInfo = {}
		hQueryInfo.szQueryName = k

		local hQuery = deepcopy( v.QueryTable )
		if hQuery ~= nil then
			local varTable = {}
			for _,Var in pairs ( v.Vars ) do
				if Var.Values ~= nil then
					varTable[Var.VarName] = Var.Values[#Var.Values]
				end
			end
			CDotaNPX:ReplaceQueryVariableValues( hQuery, varTable )
			
			hQueryInfo.eQueryType = v.QueryType

			if hQueryInfo.eQueryType == NPX_QUERY_TYPE.SUCCESS then
			--	hQuery["success_gametime"] = self.hScenario.ScenarioTimeLimit
			end

			if hQueryInfo.eQueryType == NPX_QUERY_TYPE.FAIL then
				hQuery["query_match_causes_failure"] = 1
			end

			hQueryInfo.hQueryTable = hQuery
			hQueryInfo.hProgressGoals = v.ProgressGoals
			self.nMaxScenarioRank = math.max( self.nMaxScenarioRank, #v.ProgressGoals )
		end

		table.insert( self.QueryInfos, hQueryInfo )
	end
end


----------------------------------------------------------------------------
function CDotaNPXScenario:OnTakeDamage( hVictim, hKiller, hInflictor )	
	local sVictimName = ""
	local sKillerName = ""
	local sInflictorName = ""
	
	if hVictim ~= nil then
		sVictimName = hVictim:GetUnitName()
	end

	if hKiller ~= nil then
		sKillerName = hKiller:GetUnitName()
	end

	if hInflictor ~= nil and hInflictor.GetAbilityName ~= nil then
		sInflictorName = hInflictor:GetAbilityName()
	end
	
	
	GameRules:GetAnnouncer(2):SpeakConcept ( { 
						Damage = 1,
						Victim = sVictimName,
						Aggressor = sKillerName,
						Inflictor = sInflictorName,						
					})
	if self.Tasks ~= nil then
		for _,Task in pairs ( self.Tasks ) do
			if Task:IsActive() then
				Task:ResetIdleCounter()
			end
		end
	end
end
----------------------------------------------------------------------------

function CDotaNPXScenario:LoadCombatAnalyzerQueries()
	if not self.hScenario.Queries then
		return true
	end

	self:BuildQueries()

	print( "...loading " .. #self.QueryInfos .. " combat analyzer queries..." )
	for _,hQueryInfo in pairs ( self.QueryInfos ) do
		local nQueryID = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryInfo.hQueryTable, PlayerResource:GetPlayer( 0 ), hQueryInfo.szQueryName )
		if nQueryID == -1 then
			print ( "CDotaNPXScenario:LoadCombatAnalyzerQueries - ERROR! Failed to load combat analyzer query " .. hQueryInfo.szQueryName )
			return false
		else
			if self.hPlayerHero == nil then
				print( "Query loaded and player hero is not ready!" )
			end
			print( "...loaded query " .. hQueryInfo.szQueryName .. " for player " .. PlayerResource:GetPlayerName( 0 ) )
			hQueryInfo.nQueryID = nQueryID
			hQueryInfo.nRankAchieved = 0
			hQueryInfo.nProgress = 0
		end
	end

	return true
end

----------------------------------------------------------------------------

function CDotaNPXScenario:Start()
	print( "...scenario starting!" )
	self.bStarted = true
	CustomNetTables:SetTableValue( "base_scenario", "scenario_info", { scenario_name = self.szScenarioName } )

	if self.szCheckpointTaskName ~= nil then
		local checkpointTask = self:GetTask( self.szCheckpointTaskName )
		if checkpointTask ~= nil and checkpointTask.OnCheckpoint ~= nil then
			checkpointTask:OnCheckpoint()
		end
	else
		self:IntroduceScenario()
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnPrecacheComplete( sg )
	if sg ~= nil then
		table.insert( self.hScenarioNPCSpawnGroups, sg )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnHeroFinishSpawn( hHero, hPlayer )
	if hPlayer:GetPlayerID() == 0 then
		if self.hScenario.StartingHeroLevel ~= nil then	
			local nXPToLevel = GetXPNeededToReachNextLevel( self.hScenario.StartingHeroLevel - 1 )
			if self.hScenario.StartingXP ~= nil then
				print( "Granting " .. self.hScenario.StartingXP .. " starting XP" )
				nXPToLevel = nXPToLevel + self.hScenario.StartingXP
			end
			hHero:AddExperience( nXPToLevel, DOTA_ModifyXP_Unspecified, false, true )
		end

		if self.hScenario.StartingGold ~= nil then
			nStartingGold = self.hScenario.StartingGold
		end
		PlayerResource:SetGold( hPlayer:GetPlayerID(), nStartingGold, true )
		PlayerResource:SetGold( hPlayer:GetPlayerID(), 0, false )

		if self.hScenario.StartingItems ~= nil then
			for _,Item in pairs( self.hScenario.StartingItems ) do
				hHero:AddItemByName( Item )
			end
		end

		if self.hScenario.StartingAbilities ~= nil then
			for _,AbilityName in pairs( self.hScenario.StartingAbilities ) do
				if hHero:GetAbilityPoints() > 0 then
					hAbility = hHero:FindAbilityByName( AbilityName )
					if hAbility ~= nil then
						hHero:UpgradeAbility( hAbility )
					else
						print( "Failed to find ability " .. AbilityName .. " to upgrade it" )
					end
				else
					print( "Unable to level up hero abilities because they don't have enough unspent ability points" )
				end
			end
		end

		if self.hScenario.StartingPosition ~= nil then
			FindClearSpaceForUnit( hHero, self.hScenario.StartingPosition, true )
		end

		if self.hScenario.StartingHealth ~= nil then
			hHero:SetHealth( self.hScenario.StartingHealth )
		end

		if self.hScenario.StartingMana ~= nil then
			hHero:SetMana( self.hScenario.StartingMana )
		end

		self.bPlayerHeroReady = true
		self.hPlayerHero = hHero

		self:LoadCombatAnalyzerQueries() 
		
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnSetupComplete()
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnGameRulesStateChange( nOldState, nNewState )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnNPCSpawned( hNPC )
	if hNPC == nil or hNPC:IsNull() then
		return
	end

	if not hNPC:IsRealHero() then
		local bFound = false
		for _,hSpawnedNPC in pairs ( self.hSpawnedNPCs ) do
			if hSpawnedNPC == hNPC then
				bFound = true
			end
		end

		if not bFound then
			table.insert( self.hSpawnedNPCs, hNPC )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )
	if hVictim ~= nil and self.hSpawnedNPCs ~= nil then
		for i=#self.hSpawnedNPCs,1,-1 do
			if self.hSpawnedNPCs[i] == hVictim and hVictim:IsRealHero() == false then
				table.remove( self.hSpawnedNPCs, i )
			end
		end

		self:EndHintNPC( hVictim:entindex() )
	end

	local sVictimName = ""
	local sKillerName = ""
	local sInflictorName = ""
	
	if hVictim ~= nil then
		sVictimName = hVictim:GetUnitName()
	end

	if hKiller ~= nil then
		sKillerName = hKiller:GetUnitName()
	end



	GameRules:GetAnnouncer(2):SpeakConcept ( { 
		Kill = 1,
		Victim = sVictimName,
		Aggressor = sKillerName,
	})
	if self.Tasks ~= nil then
		for _,Task in pairs ( self.Tasks ) do
			if Task:IsActive() then
				Task:ResetIdleCounter()
			end
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnTriggerStartTouch( sTriggerName, hActivator, hCaller )	

	local sActivator = ""
	local sCaller = ""
	
	if hActivator ~= nil then
		sActivator = hActivator:GetUnitName()
	end
	--[[
	if hCaller ~= nil then
		sCaller = hCaller:GetUnitName()
	end
	]]
	for _,Task in pairs ( self.Tasks ) do
		if Task:IsActive() then
			Task:OnTriggerStartTouch( sTriggerName, sActivator )			
		end
	end
	
end


----------------------------------------------------------------------------

function CDotaNPXScenario:OnThink()
	if self.bStarted == false then
		if self:IsFullyPrecached() and self.bPlayerHeroReady then
			--PauseGame( false )
			SendToServerConsole( "dota_pause_game_pause_silently 0" )
			self:OnSetupComplete()
			self:Start()
		else
			return
		end
	end
	
	local nState = GameRules:State_Get()
	if nState >= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then	
		self:CheckTasks()
		self:CheckDialogs()
	end
	
	self:ProcessScheduledFunctions()
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnTimeExpired()
	self:OnScenarioComplete( self.nScenarioRank > 0 )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnScenarioRankAchieved( nNewScenarioRank )
	print( "CDotaNPXScenario:OnScenarioRankAchieved - Rank " .. nNewScenarioRank .. " achieved!" )
	self.nScenarioRank = nNewScenarioRank
	if self.nScenarioRank >= self.nMaxScenarioRank then
		self:OnScenarioComplete( true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnScenarioComplete( bSuccess, szScenarioFailureReason )
	self:TrackAttempt()

	if bSuccess then
		print( "CDotaNPXScenario:OnScenarioComplete - Scenario complete with rank " .. self.nScenarioRank )
		FireGameEvent( "scenario_complete", {} )
	else
		print( "CDotaNPXScenario:OnScenarioComplete - Scenario failed!  Rank prior to failure was " .. self.nScenarioRank )
		if szScenarioFailureReason then
		 	print( "Failure reason = " .. szScenarioFailureReason )
		end

		FireGameEvent( "scenario_failed", {
			failure_reason = szScenarioFailureReason,
			} )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnItemPickedUp( szItemName )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnItemPhysicalDestroyed( szItemName )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnQueryProgressChanged( nQueryID, nProgress )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetQueryID() == nQueryID or Task:HasAnySubTaskWithQueryID( nQueryID ) then
			Task:OnQueryProgressChanged( nQueryID, nProgress )
		end
	end

	local hQueryInfo = self:GetQueryInfoByID( nQueryID )
	if hQueryInfo == nil then
		return
	end

	print( "CDotaNPXScenario:OnQueryProgressChanged - " .. hQueryInfo.szQueryName .. ", id " .. nQueryID .. " has reached " .. nProgress )
	hQueryInfo.nProgress = nProgress

	local nRankupGoal = 99999
	if hQueryInfo.nRankAchieved < #hQueryInfo.hProgressGoals then
		nRankupGoal = hQueryInfo.hProgressGoals[ hQueryInfo.nRankAchieved + 1 ]
	end

	while hQueryInfo.nProgress >= nRankupGoal do
		hQueryInfo.nRankAchieved = hQueryInfo.nRankAchieved + 1
		
		self:OnQueryRankAchieved( hQueryInfo )
		
		if hQueryInfo.nRankAchieved >= #hQueryInfo.hProgressGoals then
			break
		end

		nRankupGoal = hQueryInfo.hProgressGoals[ hQueryInfo.nRankAchieved + 1 ]
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnQueryRankAchieved( hQueryInfo )
	print( "CDotaNPXScenario:OnQueryRankAchieved: " .. hQueryInfo.szQueryName .. " rank " .. hQueryInfo.nRankAchieved .. " achieved!" )
	if hQueryInfo.eQueryType == NPX_QUERY_TYPE.SUCCESS then
		local nNewScenarioRank = hQueryInfo.nRankAchieved
		
		for _,hQueryInfo in pairs ( self.QueryInfos ) do
			nNewScenarioRank = math.min( hQueryInfo.nRankAchieved, nNewScenarioRank )
		end

		if nNewScenarioRank > self.nScenarioRank then
			self:OnScenarioRankAchieved( nNewScenarioRank )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnQuerySucceeded( nQueryID )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetQueryID() == nQueryID or Task:HasAnySubTaskWithQueryID( nQueryID ) then
			Task:OnQuerySucceeded( nQueryID )
		end
	end

	local hQueryInfo = self:GetQueryInfoByID( nQueryID )
	if hQueryInfo == nil or hQueryInfo.eQueryType ~= NPX_QUERY_TYPE.SUCCESS then
		return
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnQueryFailed( nQueryID )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetQueryID() == nQueryID or Task:HasAnySubTaskWithQueryID( nQueryID ) then
			Task:OnQueryFailed( nQueryID )
		end
	end

	local hQueryInfo = self:GetQueryInfoByID( nQueryID )
	if hQueryInfo == nil or hQueryInfo.eQueryType ~= NPX_QUERY_TYPE.FAIL then
		return
	end

	self:OnScenarioComplete( false )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:SetupTasks()
	if self.hScenario.Tasks == nil then
		return true
	end

	print( "...setting up " .. #self.hScenario.Tasks .. " tasks..." )
	PrintTable(self.hScenario.Tasks)
	for k,v in pairs( self.hScenario.Tasks ) do
		if v.TaskName == nil then
			
			print( "CDotaNPXScenario:SetupTasks - ERROR - Task has no TaskName!" )
			return false
		end

		print( "...processing task " .. v.TaskName )

		for _,Task in pairs ( self.Tasks ) do
			if Task:GetTaskName() == v.TaskName then
				print( "CDotaNPXScenario:SetupTasks - ERROR - Task has duplicate name " .. v.TaskName )
				return false
			end
		end

		if v.TaskType == nil then
			print( "CDotaNPXScenario:SetupTasks - ERROR - Task has no TaskType!" )
			return false
		end
		if v.TaskParams == nil then
			print( "CDotaNPXScenario:SetupTasks - ERROR - Task has no TaskParams!" )
			return false
		end
		if v.CheckTaskStart == nil then
			print( "CDotaNPXScenario:SetupTasks - ERROR - Task has no CheckTaskStart!" )
			return false	
		end

		local hTaskClass = require( "tasks/" .. v.TaskType )
		if hTaskClass == nil then
			print( "CDotaNPXScenario:SetupTasks - ERROR - Failed to create task of type " .. v.TaskType )
			return false
		end
		
		local hTask = hTaskClass( v, self )	
		hTask.CheckTaskStart = v.CheckTaskStart
		hTask.OnCheckpoint = v.OnCheckpoint
		table.insert( self.Tasks, hTask )
	end

	return true
end

----------------------------------------------------------------------------

function CDotaNPXScenario:CheckTasks()
	for _,Task in pairs ( self.Tasks ) do
		if not Task:IsActive() and not Task:IsCompleted() then
			if Task:CheckTaskStart() then					
				Task:StartTask()
			end
		end
	end

	for _,Task in pairs ( self.Tasks ) do
		if Task:IsActive() then
			Task:OnThink()
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnTaskStarted( event )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:CheckpointSkipCompleteTask( szTaskName, bSuccess, bForceStart )
	local task = self:GetTask( szTaskName )
	if task ~= nil then
		local bCheckpointSkip = true
		if bForceStart and bForceStart == true then
			task:StartTask()
		end
		task:CompleteTask( bSuccess, bCheckpointSkip )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnTaskCompleted( event )
	print( 'CDotaNPXScenario:OnTaskCompleted' )
	if event.success == 0 then
		local szFailureReason = event.failure_reason
		self:OnScenarioComplete( false, szFailureReason )
		return
	end

	local task = self:GetTask( event.task_name )
	if task ~= nil and task.OnCheckpoint ~= nil then
		print( 'CHECKPOINT SET to ' .. event.task_name )
		self.szCheckpointTaskName = event.task_name
	end

	self:CheckTasks()
end

----------------------------------------------------------------------------

function CDotaNPXScenario:IsTaskComplete( szTaskName )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetTaskName() == szTaskName then
			return Task:IsCompleted()
		else
			local subTask = Task:GetSubTaskWithName( szTaskName )
			if subTask then
				return subTask:IsCompleted()
			end
		end
	end
	return false
end

----------------------------------------------------------------------------


function CDotaNPXScenario:GetTaskCompleteTime( szTaskName )
	for _,Task in pairs( self.Tasks ) do
		if Task:GetTaskName() == szTaskName then
			return Task:GetCompletedTime()
		end
	end
	return -1
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnSpawnerFinished( event )
end


----------------------------------------------------------------------------

function CDotaNPXScenario:GetQueryInfoByID( nQueryID )
	for _,hQueryInfo in pairs ( self.QueryInfos ) do
		if hQueryInfo.nQueryID == nQueryID then
			return hQueryInfo
		end
	end

	return nil
end

----------------------------------------------------------------------------

function CDotaNPXScenario:IsTimed()
	return ( self.hScenario.ScenarioTimeLimit > 0 )
end


----------------------------------------------------------------------------

function CDotaNPXScenario:GetTimeLeft()
	return math.max( 0.0, self.hScenario.ScenarioTimeLimit - GameRules:GetDOTATime( false, false ) )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:IsFullyPrecached()
	return #self.hScenarioNPCSpawnGroups == #self.PrecachedNPCs
end

----------------------------------------------------------------------------

function CDotaNPXScenario:Restart()
	self:TrackAttempt()

	for i=#self.hSpawnedNPCs,1,-1 do
		local hNPC = self.hSpawnedNPCs[i]
		if hNPC and not hNPC:IsNull() then
			UTIL_Remove( hNPC )
		end
		table.remove( self.hSpawnedNPCs, i )
	end

	for j=#self.QueryInfos,1,-1 do
		local hQueryInfo = self.QueryInfos[j]
		if hQueryInfo and hQueryInfo.nQueryID ~= nil then
			GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( hQueryInfo.nQueryID )
		end
		table.remove( self.QueryInfos, j )
	end

	for k=#self.Tasks,1,-1 do
		local hTask = self.Tasks[k]
		if hTask then
			hTask:UnregisterTaskEvent()
		end
		table.remove( self.Tasks, k )
	end

	for _,spawner in pairs( self.rgSpawners ) do
		spawner:RemoveSpawnedUnits()
	end

	-- Clean up everything on the ground.
	while GameRules:NumDroppedItems() > 0 do
		local item = GameRules:GetDroppedItem(0)
		UTIL_RemoveImmediate( item )
	end

	-- this should catch a lot of things that should go away, like wards
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, unit in pairs( units ) do
		if unit ~= nil and unit:IsNull() == false then
			local bDestroy = false
			if unit:IsOwnedByAnyPlayer() and unit:IsRealHero() == false then
				bDestroy = true
			elseif unit:GetUnitName() == "npc_dota_weaver_swarm" then
				bDestroy = true
			elseif unit:IsOther() then -- Wards, but also catches other stuff
				bDestroy = true
			end
			if bDestroy and unit:GetUnitName() ~= "npc_dota_wisp_spirit" and unit:GetUnitName() ~= "dota_death_prophet_exorcism_spirit" and unit:GetUnitName() ~= "npc_dota_beastmaster_axe" then
				unit:ForceKill( false )
			end
		end
	end
	
	self.rgSpawners = {}
	self.rgScheduledFunctions = {}
	self.HintNPCs = {}
	self.Tasks = {}
	self.bStarted = false
	self.bPlayerHeroReady = false
	self.hPlayerHero = nil
	self.bIntroductionComplete = false

	FireGameEvent( "scenario_restarted", {} )

	self:SetupScenario()
end

----------------------------------------------------------------------------

function CDotaNPXScenario:TrackAttempt()
	local hAttempt = {}
	hAttempt["attempt_number"] = #self.Attempts + 1
	hAttempt["queries"] = self.QueryInfos
	hAttempt["scenario_rank"] = self.nScenarioRank
	hAttempt["time_left"] = self:GetTimeLeft()
	table.insert( self.Attempts, hAttempt )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:AddResultToSignOut()
	local hSignOutTable = {}
	hSignOutTable["attempts"] = self.Attempts
	return hSignOutTable
end

----------------------------------------------------------------------------

function CDotaNPXScenario:AddSpawner( spawner )
	table.insert( self.rgSpawners, spawner )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:PrecacheSpawners()
	print ( "CDotaNPXScenario:PrecacheSpawners" )
	for _,spawner in pairs( self.rgSpawners ) do
		spawner:PrecacheUnits()
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:ScheduleFunctionAtGameTime( nGameTimeIn, hFunctionIn )
	table.insert( self.rgScheduledFunctions, { nGameTime = nGameTimeIn, hFunction = hFunctionIn } )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:ProcessScheduledFunctions()
	local rgProcessed = {}
	local nCurrentTime = GameRules:GetDOTATime( false, false )

	for index, rgFunctionInfo in pairs ( self.rgScheduledFunctions ) do
		local nScheduledTime = rgFunctionInfo.nGameTime
		if ( nCurrentTime >= nScheduledTime ) then
			rgFunctionInfo.hFunction()
			table.insert( rgProcessed, index )
		end
	end

	for i = #rgProcessed, 1, -1 do
		table.remove( self.rgScheduledFunctions, rgProcessed[ i ] )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:GetSpawner( szSpawnerName )
	for _,Spawner in pairs ( self.rgSpawners ) do
		if Spawner:GetSpawnerName() == szSpawnerName then
			return Spawner
		end
	end
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXScenario:GetTask( szTaskName )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetTaskName() == szTaskName then
			return Task
		end
		local SubTask = Task:GetTask( szTaskName )
		if SubTask then
			return SubTask
		end		
	end
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXScenario:GetPlayerHero()
	return self.hPlayerHero
end

----------------------------------------------------------------------------

function CDotaNPXScenario:IntroduceUnit( hUnit, flDuration, flCameraPitch, flCameraHeight, flCameraDistance, flCameraYawRotateSpeed, flCameraInitialYaw )
	local event = {}
	event[ "ent_index" ] = hUnit:entindex()
	event[ "duration" ] = flDuration
	event[ "camera_pitch" ] = flCameraPitch
	event[ "camera_height" ] = flCameraHeight
	event[ "camera_distance" ] = flCameraDistance
	event[ "camera_yaw_rotate_speed" ] = flCameraYawRotateSpeed
	event[ "camera_initial_yaw" ] = flCameraInitialYaw

	hUnit:AddNewModifier( hUnit, nil, "modifier_provide_vision", { duration = flDuration + 1.0 } )

	CustomGameEventManager:Send_ServerToAllClients( "introduce_unit", event )

	self:ScheduleFunctionAtGameTime( GameRules:GetGameTime() + flDuration, function()
		self:EndIntroduceUnit( hUnit )
	end )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:EndIntroduceUnit( hUnit )
	CustomGameEventManager:Send_ServerToAllClients( "end_introduce_unit", event )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:IntroduceScenario()
	--override
	self:EndIntroduceScenario()
end

----------------------------------------------------------------------------

function CDotaNPXScenario:EndIntroduceScenario()
	self.bIntroductionComplete = true
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )

	CustomGameEventManager:Send_ServerToAllClients( "end_introduce_scenario", event )
end

----------------------------------------------------------------------------

return CDotaNPXScenario
