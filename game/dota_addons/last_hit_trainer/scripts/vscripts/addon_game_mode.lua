
------------------------------------------------------------------------------------------------------------------------------------------------------
-- CLastHitTrainer class
------------------------------------------------------------------------------------------------------------------------------------------------------
if CLastHitTrainer == nil then
	_G.CLastHitTrainer = class({})
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Required Files
------------------------------------------------------------------------------------------------------------------------------------------------------
require( "utility_functions" ) -- Require this first
require( "events" )

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Precache files and folders
------------------------------------------------------------------------------------------------------------------------------------------------------
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]

	PrecacheResource( "particle", "particles/newplayer_fx/last_hit_streak.vpcf", context )
	PrecacheResource( "particle", "particles/newplayer_fx/last_hit_message.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_last_hit_trainer.vsndevts", context )
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Activate CLastHitTrainer
------------------------------------------------------------------------------------------------------------------------------------------------------
function Activate()
	GameRules.AddonTemplate = CLastHitTrainer()
	GameRules.AddonTemplate:InitGameMode()
end

-- Should these be self.nScoreValues that belong to CLastHitTrainer instead?
_G.gScoreValue = {
	m_DenyBaseValue = 50,
	m_LastHitBaseValue = 100,
	m_LastHitOrDenyModForPointMultiplier = 1	-- Each deny or last hit will be multiplied against a multiplier, 
												-- determined by the following formula:
												-- 	local scoreIncrement = ( math.floor(self.m_CurrentLastHitStreakCount / gScoreValue.m_LastHitOrDenyModForPointMultiplier) + 1) * gScoreValue.m_DenyBaseValue
}

_G.gGameInfo = {
	m_fRoundDuration = 3 * 60, -- Seconds
	--m_fRoundDuration = 20, -- dev value
	m_fRoundStartTime = -1,
	m_nBronzeScoreReq = 600,
	m_nSilverScoreReq = 1600,
	m_nGoldScoreReq = 2600,
	m_nDiamondScoreReq = 3600
	--[[
	-- Dev Values
	m_nBronzeScoreReq = 100,
	m_nSilverScoreReq = 200,
	m_nGoldScoreReq = 300,
	m_nDiamondScoreReq = 400
	]]
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Initialize Mode
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetThink( "OnThink", self, "GlobalThink", 0.1 )
	GameMode:SetFixedRespawnTime( 4 )
	GameMode:SetStashPurchasingDisabled( true ) -- NO stash purchasing means no buying since we don't have any stores
	GameMode:SetDaynightCycleDisabled( true )

	PlayerResource:SetCustomTeamAssignment( 0, DOTA_TEAM_GOODGUYS ) -- put player 0 on Radiant team
	GameRules:SetCustomGameSetupTimeout( 0 ) -- set the custom game setup phase to last 60 seconds, set to 0 skip the custom game setup, or -1 to disable the timeout
	GameRules:SetPreGameTime( 0 ) -- time before horn blows
	GameRules:SetHeroSelectionTime( 999 ) 
	GameRules:SetStartingGold( 0 ) -- No gold, let's practice last hitting without items to help.
	GameRules:SetStrategyTime( 0 ) -- No time for strategy, go straight to the game.
	GameRules:SetShowcaseTime( 0 ) -- No time for strategy, go straight to the game.
	GameRules:FinishCustomGameSetup() -- We're done here, launch the game
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetTimeOfDay( 0.5 )
	GameRules:SetCreepSpawningEnabled( false )

	--[[
	self.m_IdealTriggerZone = Entities:FindByName( nil, 'trigger_ideal_creep_balance_zone' )
	print( self.m_IdealTriggerZone )
	]]

	local hRadiantSpawnEnt = Entities:FindByName( nil, "npc_dota_spawner_good_mid_staging" )
	self.m_vRadiantSpawnPos = hRadiantSpawnEnt:GetOrigin()

	local hDireSpawnEnt = Entities:FindByName( nil, "npc_dota_spawner_bad_mid_staging" )
	self.m_vDireSpawnPos = hDireSpawnEnt:GetOrigin()

	--[[
	local hPlayerSpawnEnt = Entities:FindByName( nil, "info_player_start_goodguys" )
	self.m_vPlayerSpawnPos = hPlayerSpawnEnt:GetOrigin()
	]]

	-- Colors for last hit particle
	self.m_vColorTier1 = Vector( 100, 250, 30 )
	self.m_vColorTier2 = Vector( 180, 190, 30 )
	self.m_vColorTier3 = Vector( 200, 170, 30 )
	self.m_vColorTier4 = Vector( 220, 145, 30 )
	self.m_vColorTier5 = Vector( 240, 110, 30 )
	self.m_vColorTier6 = Vector( 250, 75, 30 )
	self.m_vColorTier7 = Vector( 250, 45, 30 )
	self.m_vColorTier8 = Vector( 250, 0, 30 )

	self.m_fTimeLastCreepsSpawned = -1

	self.m_nMeleeCreepsSpawned = 0

	self.m_nRangedCreepsSpawned = 0

	self:InitializeNetworkStats()

	-- Events
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CLastHitTrainer, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CLastHitTrainer, "OnNPCSpawned" ), self )

	-- Hook game events
	local eventsToHook = {
		entity_killed = 'OnEntityKilled',
		last_hit = 'OnLastHit',
	}

	CustomGameEventManager:RegisterListener( "RoundStartButtonPressed", function(...) return self:OnRoundStartButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "NewHeroButtonPressed", function(...) return self:OnNewHeroButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LeaveButtonPressed", function(...) return self:OnLeaveButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "SwitchToNewHero", function(...) return self:SwitchToNewHero( ... ) end )

	for eventName, functionName in pairs( eventsToHook ) do
		ListenToGameEvent( eventName, Dynamic_Wrap( CLastHitTrainer, functionName ), self )
	end

	CustomNetTables:SetTableValue( "last_hit_trainer_gameinfo", "gameinfo", gGameInfo )

	self:SendStatisticsToClient()
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:InitializeNetworkStats()
	self.m_NetTableStats = {
		m_Score = 0,
		m_HighestLastHitStreakCount = 0,
		m_CurrentLastHitStreakCount = 0,
		m_LastHitCount = 0,
		m_DenyCount = 0,
		m_TotalCreepDeaths = 0,
		m_TotalLastHitOrDenyPct = 0.0,
		m_CreepsOutOfZoneCount = 0,
		m_nMeleeCreepsKilled = 0,
		m_nMeleeCreepsDenied = 0,
		m_nRangedCreepsKilled = 0,
		m_nRangedCreepsDenied = 0,
		m_nGoldFromMeleeCreeps = 0,
		m_nGoldFromRangedCreeps = 0
	}
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:DestroyCurrentRound()
	--print( "DestroyCurrentRound" )

	local hLaneCreeps = Entities:FindAllByClassname( "npc_dota_creep_lane" )
	for _, hCreep in pairs( hLaneCreeps ) do
		hCreep:ForceKill( true )
	end

	self.m_hPlayerHero:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	self.m_bPlayerInitialized = false -- initializes on the next think, right now would be too early

	self.m_fTimeLastCreepsSpawned = -1

	gGameInfo.m_fRoundStartTime = -1
	CustomNetTables:SetTableValue( "last_hit_trainer_gameinfo", "gameinfo", gGameInfo )

	self.m_bPlayingIntenseAudio = false
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:SetupNextRound()
	--print( "Setting up next round" )

	local fDelayBeforeRoundPrep = 0.0
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetThink( "ThinkPrepNextRound", self, "ThinkPrepNextRound", fDelayBeforeRoundPrep )
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Prep the next round, player gets placed at correct position and has a few seconds before creeps
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:ThinkPrepNextRound()
	if not IsServer() then
		return
	end

	--PauseGame( false )

	if self.m_hPlayerHero:HasModifier( "modifier_invulnerable" ) then
		self.m_hPlayerHero:RemoveModifierByName( "modifier_invulnerable" )
		FindClearSpaceForUnit( self.m_hPlayerHero, self.m_vRadiantSpawnPos, true )
		-- @todo: heal the hero
	end

	local fDelayBeforeRoundStart = 2.0
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetThink( "ThinkStartNextRound", self, "ThinkStartNextRound", fDelayBeforeRoundStart )

	self:InitializeNetworkStats()
	self:SendStatisticsToClient()

	EmitGlobalSound( "RoundStart" )

	return nil
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Start the next round, get creeps going etc.
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:ThinkStartNextRound()
	if not IsServer() then
		return
	end

	--print( "Start round" )

	self:SpawnLaneCreeps()

	-- @todo: spawn new towers

	gGameInfo.m_fRoundStartTime = GameRules:GetGameTime()
	CustomNetTables:SetTableValue( "last_hit_trainer_gameinfo", "gameinfo", gGameInfo )

	return nil
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------------------------------
function CLastHitTrainer:SpawnLaneCreeps()
	--print( "SpawnLaneCreeps" )

	-- Radiant creeps
	for i = 1, 3 do
		local hCreep = CreateUnitByName( "npc_dota_creep_goodguys_melee", self.m_vRadiantSpawnPos,
			true, nil, nil, DOTA_TEAM_GOODGUYS
		)
		if hCreep ~= nil then
			--print( string.format( "%s wants to attack-move to this position:", hCreep:GetUnitName() ) )
			--print( self.m_vDireSpawnPos )
			ExecuteOrderFromTable({
				UnitIndex = hCreep:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.m_vDireSpawnPos,
				Queue = true,
			})

			self.m_nMeleeCreepsSpawned = self.m_nMeleeCreepsSpawned	+ 1
		end
	end

	local hCreep = CreateUnitByName( "npc_dota_creep_goodguys_ranged", self.m_vRadiantSpawnPos,
		true, nil, nil, DOTA_TEAM_GOODGUYS
	)
	if hCreep ~= nil then
		--print( string.format( "%s wants to attack-move to this position:", hCreep:GetUnitName() ) )
		--print( self.m_vDireSpawnPos )
		ExecuteOrderFromTable({
			UnitIndex = hCreep:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = self.m_vDireSpawnPos,
			Queue = true,
		})

		self.m_nRangedCreepsSpawned = self.m_nRangedCreepsSpawned	+ 1
	end
	
	-- Dire Creeps
	for i = 1, 3 do
		local hCreep = CreateUnitByName( "npc_dota_creep_badguys_melee", self.m_vDireSpawnPos,
			true, nil, nil, DOTA_TEAM_BADGUYS
		)
		if hCreep ~= nil then
			--print( string.format( "%s wants to attack-move to this position:", hCreep:GetUnitName() ) )
			--print( self.m_vRadiantSpawnPos )
			ExecuteOrderFromTable({
				UnitIndex = hCreep:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.m_vRadiantSpawnPos,
				Queue = true,
			})

			self.m_nMeleeCreepsSpawned = self.m_nMeleeCreepsSpawned	+ 1
		end
	end

	local hCreep = CreateUnitByName( "npc_dota_creep_badguys_ranged", self.m_vDireSpawnPos,
		true, nil, nil, DOTA_TEAM_BADGUYS
	)
	if hCreep ~= nil then
		--print( string.format( "%s wants to attack-move to this position:", hCreep:GetUnitName() ) )
		--print( self.m_vRadiantSpawnPos )
		ExecuteOrderFromTable({
			UnitIndex = hCreep:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = self.m_vRadiantSpawnPos,
			Queue = true,
		})

		self.m_nRangedCreepsSpawned = self.m_nRangedCreepsSpawned	+ 1
	end

	self.m_fTimeLastCreepsSpawned = GameRules:GetGameTime()
end
