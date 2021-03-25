---------------------------------------------------------------------------

if CDotaNPX == nil then
	CDotaNPX = class({})
	_G.CDotaNPX = CDotaNPX
end

---------------------------------------------------------------------------

require( "constants" )
require( "precache" )
require( "events" )
require( "spawner" )
require( "npx_scenario" )
require( "npx_task" )
require( "utility_functions" )

---------------------------------------------------------------------------

LinkLuaModifier( "modifier_no_xp", "modifiers/modifier_no_xp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tank_creep_damage", "modifiers/modifier_tank_creep_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_healing", "modifiers/modifier_disable_healing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_muted", "modifiers/modifier_hero_muted", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_command_restricted", "modifiers/modifier_command_restricted", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_no_damage", "modifiers/modifier_no_damage", LUA_MODIFIER_MOTION_NONE )


-------------------------------------------------------------------------- 

function Precache( context )
	for _,Item in pairs( g_ItemPrecache ) do
		PrecacheItemByNameSync( Item, context )
	end

	for _,Unit in pairs( g_UnitPrecache ) do
		PrecacheUnitByNameAsync( Unit, function( unit ) end )
	end

	for _,Model in pairs( g_ModelPrecache ) do
		PrecacheResource( "model", Model, context  )
	end

	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context  )
	end

	for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
		PrecacheResource( "particle_folder", ParticleFolder, context )
	end

	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end
end

---------------------------------------------------------------------------

function Activate()
	GameRules.DotaNPX = CDotaNPX()
	GameRules.DotaNPX:InitGameMode()
end

---------------------------------------------------------------------------

function CDotaNPX:InitGameMode()
	self.CurrentScenario = nil
	self.flNextTimerConsoleNotify = -1
	self.AbilityKV = LoadKeyValues( "scripts/npc_abiliies.txt" )
	self.ItemKV = LoadKeyValues( "scripts/items.txt" )

	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( CDotaNPX, "OnPlayerConnected" ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDotaNPX, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaNPX, "OnEntityKilled" ), self )
	ListenToGameEvent( "dota_game_state_change", Dynamic_Wrap( CDotaNPX, "OnGameRulesStateChange" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDotaNPX, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_item_physical_destroyed", Dynamic_Wrap( CDotaNPX, "OnItemPhysicalDestroyed" ), self )
	ListenToGameEvent( "dota_on_hero_finish_spawn", Dynamic_Wrap( CDotaNPX, "OnHeroFinishSpawn" ), self )
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( CDotaNPX, "OnGameFinished" ), self )
	ListenToGameEvent( "task_started", Dynamic_Wrap( CDotaNPX, "OnTaskStarted" ), self )
	ListenToGameEvent( "task_completed", Dynamic_Wrap( CDotaNPX, "OnTaskCompleted" ), self )
	ListenToGameEvent( "spawner_finished", Dynamic_Wrap( CDotaNPX, "OnSpawnerFinished" ), self )
	ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CDotaNPX, "OnTakeDamage" ), self )
	ListenToGameEvent( "modifier_event", Dynamic_Wrap( CDotaNPX, "OnModifierEvent" ), self )
	ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPX, "OnTriggerStartTouch" ), self )
	CustomGameEventManager:RegisterListener( "ui_hint_advanced", function( ... ) return self:OnUIHintAdvanced( ... ) end )
	CustomGameEventManager:RegisterListener( "restart_scenario", function(...) return self:OnRestartScenarioClicked( ... ) end )
	CustomGameEventManager:RegisterListener( "exit_scenario", function( ... ) return self:OnExitScenarioClicked( ... ) end )
	CustomGameEventManager:RegisterListener( "win_scenario", function( ... ) return self:OnWinScenarioClicked( ... ) end )

	GameRules:SetCustomGameSetupTimeout( 0 ) 
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetHeroSelectPenaltyTime( 0.0 )
	GameRules:SetShowcaseTime( 0 )
	GameRules:SetPostGameTime( 0.0 )

	GameRules:GetGameModeEntity():ListenForQueryProgressChanged( Dynamic_Wrap( CDotaNPX, "OnQueryProgressChanged" ), self )
	GameRules:GetGameModeEntity():ListenForQuerySucceeded( Dynamic_Wrap( CDotaNPX, "OnQuerySucceeded" ), self )
	GameRules:GetGameModeEntity():ListenForQueryFailed( Dynamic_Wrap( CDotaNPX, "OnQueryFailed" ), self )
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CDotaNPX, "ModifyGoldFilter" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( CDotaNPX, "ModifyExperienceFilter" ), self )

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", NPX_THINK_TIME )

	self:RegisterConCommands()	
end

--------------------------------------------------------------------------------

function CDotaNPX:RegisterConCommands()
	local eCommandFlags = FCVAR_CHEAT
	
	Convars:RegisterCommand( "npx_fade_to_black", function( commandName, szFadeDown ) self:Dev_FadeToBlack( szFadeDown ) end, "Debug for the fade to black", eCommandFlags )
end

--------------------------------------------------------------------------------

function CDotaNPX:Dev_FadeToBlack( szFadeDown )
	local nFade = tonumber( szFadeDown )
	FireGameEvent( "fade_to_black", {
		fade_down = nFade,
		} )
end

---------------------------------------------------------------------------

function CDotaNPX:ConvertTemplateToQueryTable( szFile )
	local szFileName = "scripts/tournaments/challenge_templates/" .. szFile .. ".txt"
	local hTemplateTable = LoadKeyValues( szFileName )
	if hTemplateTable == nil then
		print( "CDotaNPX:ConvertTemplateToQueryTable: ERROR! Failed to load template file " .. szFileName )
		return
	end
	local hQueryTable = nil
	if hTemplateTable ~= nil then
		for k,v in pairs( hTemplateTable ) do
			if k == "events" then
				hQueryTable = v
			end
		end
	end

	return hQueryTable
end

---------------------------------------------------------------------------

function CDotaNPX:ReplaceQueryVariableValues( hQueryTable, hVarTable )
	if hQueryTable ~= nil and hVarTable ~= nil then
		for szVarName,varValue in pairs ( hVarTable ) do
			--print( "--> Replacing " .. szVarName .. " with " .. varValue )
			self:RecursiveReplaceVariableValue( hQueryTable, szVarName, varValue )
		end
	end
end

---------------------------------------------------------------------------

function CDotaNPX:RecursiveReplaceVariableValue( hTable, szVarName, varValue )
	for k,v in pairs( hTable ) do
		if type( v ) == "table" then
			self:RecursiveReplaceVariableValue( v, szVarName, varValue )
		else
			if v == szVarName then
				hTable[k] = varValue
			end
		end
	end
end

---------------------------------------------------------------------------

function CDotaNPX:GenerateKilleaterQueryTable( nKilleaterID, szAggregator )
	local hQueryTable = 
	{
		matching_type =	"linear_series",
		query =
		{
			killeater =
			{
				event 				= "kill_eater",
				caster 				= "!hero",
				kill_eater_event	= nKilleaterID,
				storage =
				{
					{
						key 		= "value",
						aggregator	= szAggregator,
					},
				},
			},
		},
		
		progress_stored_in = 1,
		post_tests =
		{
			test_killeater =
			{
				storage =	1,
				compare	= 	">=",
				amount  =	"<killeater_count>",
			},
		},
	}

	return hQueryTable
end

---------------------------------------------------------------------------

function CDotaNPX:SetupScenario( szScenario )
	print( "CDotaNPX:SetupScenario - Setting up scenario " .. szScenario .. "..." )
	local hScenarioClass = require( "scenarios/" .. szScenario )
	self.CurrentScenario = hScenarioClass( szScenario )

	local bSuccess = self.CurrentScenario:SetupScenario()
	if not bSuccess then
		print( "...FAILED!" )
		return
	end

	print( "...setup success, awaiting precache..." )
end

---------------------------------------------------------------------------

function CDotaNPX:RestartScenario()
	print( "CDotaNPX:RestartScenario - Restarting scenario..." )
	GameRules:ResetDefeated()
	GameRules:ResetToCustomGameSetup()
	self.CurrentScenario:Restart()
end

---------------------------------------------------------------------------

function CDotaNPX:ExitScenario()
	print( "CDotaNPX:ExitScenario - Exiting scenario..." )
	GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
end

---------------------------------------------------------------------------

function CDotaNPX:WinScenario()
	print( "CDotaNPX:WinScenario - Winning scenario..." )
	GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
end

---------------------------------------------------------------------------

function CDotaNPX:IsTaskComplete( szTaskName )
	if self.CurrentScenario == nil then
		return false
	end

	return self.CurrentScenario:IsTaskComplete( szTaskName )
end


---------------------------------------------------------------------------

function CDotaNPX:GetTask( szTaskName )
	if self.CurrentScenario == nil then
		return nil
	end

	return self.CurrentScenario:GetTask( szTaskName )
end



