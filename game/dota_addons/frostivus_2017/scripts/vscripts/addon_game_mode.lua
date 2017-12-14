-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/units/heroes/hero_lich/lich_chain_frost.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf", context )
  PrecacheResource("particle", "particles/abilities/sniper_assassinate.vpcf", context )

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("item_rune_heal", context)
  -- These abilities' particles don't seem to async precache correctly on the client
  PrecacheItemByNameSync("furion_teleport_lua", context)
  PrecacheItemByNameSync("whirling_death_lua", context)
  PrecacheItemByNameSync("timber_chain_lua", context)
  PrecacheItemByNameSync("chakram_lua", context)
  PrecacheItemByNameSync("chakram_return_lua", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
  PrecacheUnitByNameSync("npc_dota_hero_furion", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()

  if IsInToolsMode() then
    Timers:CreateTimer(2, function()
      Tutorial:AddBot("npc_dota_hero_sven", "", "", false)
    end)
  end
end