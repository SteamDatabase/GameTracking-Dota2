-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

require('utility_functions')
require('minigames/minigame_helper')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
  print(" Players Loaded")

  GameRules.time_waited_for_players = 0
  Timers:CreateTimer(1, function()
    print("  Checking for heroes")

    if GameRules.time_waited_for_players < 15 then
      GameRules.time_waited_for_players = GameRules.time_waited_for_players + 1
      for i = 0, GameRules.num_players - 1 do
        if PlayerResource:GetSelectedHeroEntity(i) == nil then
          print("  Bailing on hero " .. i .. " waited " .. GameRules.time_waited_for_players .. " seconds!")
          return 1
        end
      end
    end

    print("  Starting Game")

    GameMode.heroList = HeroList:GetAllHeroes()
    GameMode:StartRandomGame()
  end)
  

end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]

function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())
  Timers:CreateTimer(.03, function()
    for i=0,8 do
      local item = hero:GetItemInSlot(i)
      if item ~= nil and item:GetAbilityName() == "item_tpscroll" then
        --hero:RemoveItem(item)
        item:RemoveSelf()
      end
    end
  end)
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  Convars:RegisterCommand( "frostivus_start_game_by_name", function(name, gameName)
      GameMode:StartGameByName(gameName)
    end, "End the current minigame and start the one with this name.", FCVAR_CHEAT )
  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')

  GameRules:SetCustomGameAllowHeroPickMusic( false )
  GameRules:SetCustomGameAllowBattleMusic( false )
  GameRules:SetCustomGameAllowMusicAtGameStart( true )

  GameRules.teams = {}
  GameRules.teamToPlayer = {}
  GameRules.score = {}
  GameRules.round = 0
  GameRules.num_players = 0
  GameRules.MAX_ROUNDS = 10

  nPlayerID = 0

  for team, player_count in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
    PlayerResource:SetCustomTeamAssignment( nPlayerID, team )
    GameRules.teams[team] = true
    GameRules.teamToPlayer[team] = nPlayerID
    GameRules.score[team] = 0
    nPlayerID = nPlayerID + 1
  end

  GameRules:SetCustomGameSetupTimeout( 0 ) 
  GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
  GameRules:LockCustomGameSetupTeamAssignment( true )
  GameRules:EnableCustomGameSetupAutoLaunch( true )

  GameRules.num_players = nPlayerID

end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  GameMode:StartGameByName(gameName)
  -- if cmdPlayer then
  --   local playerID = cmdPlayer:GetPlayerID()
  --   if playerID ~= nil and playerID ~= -1 then
  --     -- Do something here for the player who called this command
  --   end
  -- end

  print( '*********************************************' )
end

function GameMode:CustomGameSetup()
  return
end