
print( "JungleSpirits addon is booting up..." )

--------------------------------------------------------------------------------

if CJungleSpirits == nil then
	CJungleSpirits = class({})
	_G.CJungleSpirits = CJungleSpirits
end

--------------------------------------------------------------------------------

require( "utility_functions" ) -- require first
require( "constants" ) -- require second

require( "ai/ai_shared" )
require( "dev_commands" )
require( "events" )
require( "filters" )
require( "gemdrop" )
require( "gems" )
require( "precache" )
require( "spirits" )
require( "voice_lines" )

--------------------------------------------------------------------------------

-- Precache resources, this hook happens before most things
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

--------------------------------------------------------------------------------

-- Actually make the game mode when we activate
function Activate()
	GameRules.JungleSpirits = CJungleSpirits()
	GameRules.JungleSpirits:InitGameMode()
	LinkModifiers()
end

--------------------------------------------------------------------------------

function LinkModifiers()
	LinkLuaModifier( "modifier_provides_fow_position", "modifiers/modifier_provides_fow_position", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_jungle_spirit_inactive", "modifiers/creatures/modifier_jungle_spirit_inactive", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_jungle_spirit_marching", "modifiers/creatures/modifier_jungle_spirit_marching", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_jungle_spirit_immunity", "modifiers/creatures/modifier_jungle_spirit_immunity", LUA_MODIFIER_MOTION_NONE )
end

--------------------------------------------------------------------------------

function CJungleSpirits:InitGameMode()
	-- Custom console commands
	--Convars:RegisterCommand( "JungleSpirits_status_report", function(...) return self:_StatusReportConsoleCommand( ... ) end, "Report the status of the current JungleSpirits game.", FCVAR_CHEAT )

	printf("[MOROKAI] Initalizing Game Mode..")

	Convars:RegisterCommand( "jungle_spirits_new_round", function( ... ) return self:ForceNewSpiritRound( ... ) end, "Start the next Jungle Spirit round.", FCVAR_CHEAT )
	Convars:RegisterCommand( "jungle_spirits_force_spawn_gem", function( ... ) return self:ForceSpawnGem( ... ) end, "Force a gem drop after the warning period.", FCVAR_CHEAT )
	Convars:RegisterCommand( "jungle_spirits_force_spawn_gem_immediate", function( ... ) return self:ForceSpawnGemImmediate( ... ) end, "Force a gem drop immediately, skipping the warning period.", FCVAR_CHEAT )
	Convars:RegisterCommand( "jungle_spirits_give_gems", function( ... ) return self:GiveGems( ... ) end, "Increase all player heroes' gem counts. Pass the value of gems to gain. Default amount is 100.", FCVAR_CHEAT )
	Convars:RegisterCommand( "jungle_spirits_manual_control", function( ... ) return self:ToggleSpiritManualControl( ... ) end, "Toggle manual player control of the Mo'rokai.", FCVAR_CHEAT )

	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetTowerBackdoorProtectionEnabled( true )
	GameMode:SetHUDVisible( DOTA_DEFAULT_UI_CUSTOMUI_BEHIND_HUD_ELEMENTS, false );

	self._hDireSpirit = nil
	self._hRadiantSpirit = nil

	self._nMarchesStarted = 0

	self._hasWarnedGemSpawn = false

	self._flItemExpireTime = GEM_EXPIRE_TIME

	self._bManualControl = false

	self.nCarePackageCount = 0

	self.EventMetaData = {}
	self.EventMetaData[ "event_name" ]  = "jungle_spirits_2019"
	self.EventMetaData[ "radiant_upgrade_order" ] = {}
	self.EventMetaData[ "dire_upgrade_order" ] = {}
	self.SignOutTable = {}
	self.SignOutTable["stats"] = {}
	self.SignOutTable["points"] = {}


	self._hEventGameDetails = GetLobbyEventGameDetails()

	printf("[MOROKAI] EventGameDetails table:")
	if self._hEventGameDetails then
	    DeepPrintTable(self._hEventGameDetails)
	else
		printf("NOT FOUND!!")
	end

	-- parse dev mode starting flags
	self._bDevMode = (GameRules:GetGameSessionConfigValue("DevMode", "false") == "true")
	self._szDevHero = GameRules:GetGameSessionConfigValue("DevHero", nil)
	
	if self._bDevMode then
		GameRules:SetPreGameTime( 5.0 )
	end

	GameRules:SetCustomGameSetupTimeout( 0 ) 
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 12 )

	if self._bDevMode then
		GameRules:SetHeroSelectionTime( 20.0 )
		GameRules:SetHeroSelectPenaltyTime( 0.0 )
		GameRules:SetStrategyTime( 0 )
		GameRules:SetShowcaseTime( 0 )
		GameRules:SetPreGameTime( 5.0 )
		GameRules:SetPostGameTime( 10.0 )
	end

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CJungleSpirits, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CJungleSpirits, "OnEntityKilled" ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CJungleSpirits, "OnGameRulesStateChange" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CJungleSpirits, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_creature_gained_level", Dynamic_Wrap( CJungleSpirits, "OnCreatureGainedLevel" ), self )
	ListenToGameEvent( "dota_on_hero_finish_spawn", Dynamic_Wrap( CJungleSpirits, "OnHeroFinishSpawn" ), self )
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( CJungleSpirits, "OnGameFinished" ), self )

	ListenToGameEvent( "tree_cut", Dynamic_Wrap( CJungleSpirits, 'OnTreeCut' ), self )

	GameMode:SetModifierGainedFilter( Dynamic_Wrap( CJungleSpirits, "ModifierGainedFilter" ), self )
	GameMode:SetModifyGoldFilter( Dynamic_Wrap( CJungleSpirits, "ModifyGoldFilter"), self )
	GameMode:SetModifyExperienceFilter( Dynamic_Wrap( CJungleSpirits, "ModifyExperienceFilter" ), self )

	CustomGameEventManager:RegisterListener( "branch_button_clicked", function(...) return self:OnBranchButtonClicked( ... ) end )

	GameMode:SetUseDefaultDOTARuneSpawnLogic( true )

	GameMode:SetThink( "OnThink", self, 0.25 )
end

--------------------------------------------------------------------------------

function CJungleSpirits:AssignTeams()
	if PlayerResource:HaveAllPlayersJoined() then	

		local nPlayersPerTeam = min(5,max(1,PlayerResource:NumPlayers()/2))
		printf( "[MOROKAI] Assigning teams.. %d v %d", nPlayersPerTeam, nPlayersPerTeam )

		-- Adjust team limits
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, nPlayersPerTeam )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, nPlayersPerTeam )

		for nPlayerID = 0, PlayerResource:NumPlayers()-1 do
			local nTeam
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then 
				nTeam = DOTA_TEAM_GOODGUYS
			elseif PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_BADGUYS  then 
				nTeam = DOTA_TEAM_BADGUYS
			else
				nTeam = DOTA_TEAM_GOODGUYS
				if nPlayerID >= nPlayersPerTeam then 
					nTeam = DOTA_TEAM_BADGUYS
				end	
			end
			printf("[MOROKAI] Assigning PlayerID %d to Team %d", nPlayerID, nTeam)
			PlayerResource:SetCustomTeamAssignment( nPlayerID, nTeam )
		end
		if self.bFillWithBots == true then
			GameRules:BotPopulate()
		end

	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:ForceAssignHeroes()
	print( "ForceAssignHeroes()" )
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
			if self._bDevMode and self._szDevHero ~= nil then
				printf("[MOROKAI] Setting selected hero to %s", self._szDevHero)
				hPlayer:SetSelectedHero( self._szDevHero )
			else
				print( " [MOROKAI] Hero selection time is over: forcing nPlayerID " .. nPlayerID .. " to random a hero." )
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnTreeCut( event )
	if event.killerID == nil then
		return
	end

	local hKiller = PlayerResource:GetSelectedHeroEntity( event.killerID )

	local hBuff = nil

	if hKiller ~= nil and hKiller:IsNull() == false then
		hBuff = hKiller:FindModifierByName( "modifier_jungle_spirit_volcano_golden_tree" )
	end

	if hBuff == nil then
		return
	end

	local chance = hBuff:GetAbility():GetSpecialValueFor( "chance" )
	if ( RandomFloat ( 0 , 1 ) > chance ) then
		return
	end

	local nLevelMultiplierMax = hBuff:GetAbility():GetSpecialValueFor( "level_multiplier_max" )
	local nLevelMultiplierMin = hBuff:GetAbility():GetSpecialValueFor( "level_multiplier_min" )
	local fVariance = hBuff:GetAbility():GetSpecialValueFor( "variance" )

	local multiplier = RemapVal(hKiller:GetLevel(), 1, 25, nLevelMultiplierMax, nLevelMultiplierMin  )

	local nGoldToDrop = hKiller:GetLevel() * multiplier * RandomFloat( 1 - fVariance, 1 + fVariance)

	local vPos = Vector( event.tree_x, event.tree_y, 0 )
	print("vPos", vPos)

	self:DropGoldBag( vPos, nGoldToDrop )
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetEventGameDetails( nPlayerID )
	local szAccountID = tostring( PlayerResource:GetSteamAccountID( nPlayerID ) )

	if not self._hEventGameDetails then
		return nil
	end

	for nPlayerRecord = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local szPlayerRecord = string.format( "Player%d", nPlayerRecord )
		if self._hEventGameDetails[szPlayerRecord] ~= nil then
			local szRecordAccountID = self._hEventGameDetails[szPlayerRecord]['account_id']
			if szRecordAccountID ~= nil and szRecordAccountID == szAccountID then
				return self._hEventGameDetails[szPlayerRecord]
			end
		end
	end

	return nil

end

--------------------------------------------------------------------------------

function CJungleSpirits:ModifyExperienceFilter( filterTable )
	--printf( "ModifyExperienceFilter - filterTable:" )
	--PrintTable( filterTable )

	local player = PlayerResource:GetPlayer( filterTable[ "player_id_const" ] )
	if player == nil then
		return true
	end

	--printf( "  before - filterTable[ \"experience\" ] == %d", filterTable[ "experience" ] )

	filterTable[ "experience" ] = filterTable[ "experience" ] * HERO_EXPERIENCE_GAIN_MULTIPLIER

	--printf( "  after - filterTable[ \"experience\" ] == %d", filterTable[ "experience" ] )

	return true
end

--------------------------------------------------------------------------------

function CJungleSpirits:ModifyGoldFilter( filterTable )
	--printf( "ModifyGoldFilter - filterTable:" )
	--PrintTable( filterTable )

	local player = PlayerResource:GetPlayer( filterTable[ "player_id_const" ] )

	local hero = player:GetAssignedHero()
	if player == nil then
		return true
	end

	--printf( "  before - filterTable[ \"gold\" ] == %d", filterTable[ "gold" ] )

	filterTable[ "gold" ] = filterTable[ "gold" ] * HERO_GOLD_GAIN_MULTIPLIER

	--printf( "  before - filterTable[ \"gold\" ] == %d", filterTable[ "gold" ] )

	return true
end
