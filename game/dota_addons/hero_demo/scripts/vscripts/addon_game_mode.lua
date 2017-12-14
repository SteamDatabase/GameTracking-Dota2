--[[ Hero Demo game mode ]]
-- Note: Hero Demo makes use of some mode-specific Dota2 C++ code for its activation from the main Dota2 UI.  Regular custom games can't do this.

print( "Hero Demo game mode loaded." )

_G.NEUTRAL_TEAM = 4 -- global const for neutral team int
_G.DOTA_MAX_ABILITIES = 16
_G.HERO_MAX_LEVEL = 25

LinkLuaModifier( "lm_take_no_damage", LUA_MODIFIER_MOTION_NONE )

-- "demo_hero_name" is a magic term, "default_value" means no string was passed, so we'd probably want to put them in hero selection
sHeroSelection = GameRules:GetGameSessionConfigValue( "demo_hero_name", "default_value" )
print( "sHeroSelection: " .. sHeroSelection )

------------------------------------------------------------------------------------------------------------------------------------------------------
-- HeroDemo class
------------------------------------------------------------------------------------------------------------------------------------------------------
if CHeroDemo == nil then
	_G.CHeroDemo = class({}) -- put CHeroDemo in the global scope
	--refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Required .lua files, which just exist to help organize functions contained in our addon.  Make sure to call these beneath the mode's class creation.
------------------------------------------------------------------------------------------------------------------------------------------------------
require( "events" )
require( "utility_functions" )

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Precache files and folders
------------------------------------------------------------------------------------------------------------------------------------------------------
function Precache( context )
	PrecacheUnitByNameSync( sHeroSelection, context )
	PrecacheUnitByNameSync( "npc_dota_hero_axe", context )
	PrecacheUnitByNameSync( "npc_dota_hero_antimage", context )
	PrecacheUnitByNameSync( "npc_dota_hero_target_dummy", context )
end

--------------------------------------------------------------------------------
-- Activate HeroDemo mode
--------------------------------------------------------------------------------
function Activate()
	-- When you don't have access to 'self', use 'GameRules.herodemo' instead
		-- example Function call: GameRules.herodemo:Function()
		-- example Var access: GameRules.herodemo.m_Variable = 1
    GameRules.herodemo = CHeroDemo()
    GameRules.herodemo:InitGameMode()
end

--------------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------------
function CHeroDemo:InitGameMode()
	print( "Initializing Hero Demo mode" )
	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetCustomGameForceHero( sHeroSelection ) -- sHeroSelection string gets piped in by dashboard's demo button
	GameMode:SetTowerBackdoorProtectionEnabled( true )
	GameMode:SetFixedRespawnTime( 4 )
	--GameMode:SetBotThinkingEnabled( true ) -- the ConVar is currently disabled in C++
	-- Set bot mode difficulty: can try GameMode:SetCustomGameDifficulty( 1 )

	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetPreGameTime( 0 )
	GameRules:SetCustomGameSetupTimeout( 0 ) -- skip the custom team UI with 0, or do indefinite duration with -1

	GameMode:SetContextThink( "HeroDemo:GameThink", function() return self:GameThink() end, 0 )

	-- Events
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CHeroDemo, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CHeroDemo, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CHeroDemo, "OnItemPurchased" ), self )
	ListenToGameEvent( "npc_replaced", Dynamic_Wrap( CHeroDemo, "OnNPCReplaced" ), self )

	CustomGameEventManager:RegisterListener( "WelcomePanelDismissed", function(...) return self:OnWelcomePanelDismissed( ... ) end )
	CustomGameEventManager:RegisterListener( "RefreshButtonPressed", function(...) return self:OnRefreshButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LevelUpButtonPressed", function(...) return self:OnLevelUpButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "MaxLevelButtonPressed", function(...) return self:OnMaxLevelButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "FreeSpellsButtonPressed", function(...) return self:OnFreeSpellsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "InvulnerabilityButtonPressed", function(...) return self:OnInvulnerabilityButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "SpawnAllyButtonPressed", function(...) return self:OnSpawnAllyButtonPressed( ... ) end ) -- deprecated
	CustomGameEventManager:RegisterListener( "SpawnEnemyButtonPressed", function(...) return self:OnSpawnEnemyButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LevelUpEnemyButtonPressed", function(...) return self:OnLevelUpEnemyButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "DummyTargetButtonPressed", function(...) return self:OnDummyTargetButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "RemoveSpawnedUnitsButtonPressed", function(...) return self:OnRemoveSpawnedUnitsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LaneCreepsButtonPressed", function(...) return self:OnLaneCreepsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "ChangeHeroButtonPressed", function(...) return self:OnChangeHeroButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "ChangeCosmeticsButtonPressed", function(...) return self:OnChangeCosmeticsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "PauseButtonPressed", function(...) return self:OnPauseButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LeaveButtonPressed", function(...) return self:OnLeaveButtonPressed( ... ) end )

	SendToServerConsole( "sv_cheats 1" )
	SendToServerConsole( "dota_hero_god_mode 0" )
	SendToServerConsole( "dota_ability_debug 0" )
	SendToServerConsole( "dota_creeps_no_spawning 0" )
	SendToServerConsole( "dota_easybuy 1" )
	--SendToServerConsole( "dota_bot_mode 1" )

	self.m_sHeroSelection = sHeroSelection -- this seems redundant, but events.lua doesn't seem to know about sHeroSelection

	self.m_bPlayerDataCaptured = false
	self.m_nPlayerID = 0

	--self.m_nHeroLevelBeforeMaxing = 1 -- unused now
	--self.m_bHeroMaxedOut = false -- unused now
	
	self.m_nALLIES_TEAM = 2
	self.m_tAlliesList = {}
	self.m_nAlliesCount = 0

	self.m_nENEMIES_TEAM = 3
	self.m_tEnemiesList = {}

	self.m_bFreeSpellsEnabled = false
	self.m_bInvulnerabilityEnabled = false
	self.m_bCreepsEnabled = true

	local hNeutralSpawn = Entities:FindByName( nil, "neutral_caster_spawn" )
	if ( hNeutralSpawn == NIL ) then
		hNeutralSpawn = Entities:CreateByClassname( "info_target" );
	end

	self._hNeutralCaster = CreateUnitByName( "npc_dota_neutral_caster", hNeutralSpawn:GetAbsOrigin(), false, nil, nil, NEUTRAL_TEAM )
	

	PlayerResource:SetCustomTeamAssignment( self.m_nPlayerID, self.m_nALLIES_TEAM ) -- put PlayerID 0 on Radiant team (== team 2)
end

--------------------------------------------------------------------------------
-- Main Think
--------------------------------------------------------------------------------
function CHeroDemo:GameThink()
	--print( "#self.m_tEnemiesList == " .. #self.m_tEnemiesList .. " | GameTime == " .. tostring( string.format( "%.0f", GameRules:GetGameTime() ) ) )

	return 0.5
end