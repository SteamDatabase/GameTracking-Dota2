g_ItemPrecache =
{
	"item_tombstone",
	"item_cavern_bag_of_gold",
	"item_health_potion",
	"item_mana_potion",
	"item_tome_of_knowledge_cavern",
	"item_cavern_dynamite",
}

g_UnitPrecache =
{
	-- cavern assets
	"npc_dota_minimage",
	"npc_dota_ranged_creep_linear",
	"npc_dota_creature_ogre_tank",
	"npc_dota_creature_techies_land_mine",
	"npc_dota_creature_small_omni",
	"npc_dota_creature_large_pangoballer",
	"npc_dota_crate",
	"npc_dota_creature_enigma",
	"npc_dota_creature_satyr_soulstealer",
	"npc_dota_creature_earthshaker",
	"npc_dota_creature_pugna",
	"npc_dota_creature_troll_camp1",
	"npc_dota_statue_bounty_hunter",
	"npc_dota_creature_wraith_king",
	"npc_dota_creature_sniper",
	"npc_dota_creature_viper",
	"npc_dota_creature_lycan",
	"npc_dota_cavern_shop",
	"npc_dota_creature_invoker",
	"npc_dota_creature_lich",
	"npc_dota_creature_small_eimermole",
	"npc_dota_creature_large_eimermole",
	"npc_dota_creature_dark_willow",
	"npc_dota_creature_night_stalker",
	"npc_dota_cavern_life_stealer",

	"npc_treasure_chest", -- Treasure
	"npc_treasure_chest_anim", -- Treasure
	"npc_special_treasure_chest", -- Special Treasure
	"npc_special_treasure_chest_anim", -- Special Treasure
	"npc_dota_creature_armed_dynamite",
	"npc_dota_cavern_gate_destructible_tier1",
	"npc_dota_cavern_gate_destructible_tier1_anim",
	"npc_dota_cavern_gate_destructible_tier2",
	"npc_dota_cavern_gate_destructible_tier2_anim",
	"npc_dota_cavern_gate_destructible_tier3",
	"npc_dota_cavern_gate_destructible_tier3_anim",
	"npc_dota_cavern_gate_blocked",

	-- dota assets
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_undying",
	"npc_dota_lycan_wolf1",
	"npc_dota_lycan_wolf2",
	"npc_dota_lycan_wolf3",
	"npc_dota_lycan_wolf4",
}

g_ModelPrecache =
{
	-- cavern assets
	"models/gameplay/breakingcrate_dest.vmdl", -- npc_dota_crate
	"models/creeps/ogre_1/large_ogre.vmdl", -- Ogres
	"models/props/traps/pendulum/pendulum_extended.vmdl",
	
	-- dota assets
	"models/props_rock/riveredge_rock_wall003a.vmdl",
	"models/props_gameplay/cheese_01.vmdl", -- Cheeeese
	"models/props_gameplay/cheese_large.vmdl", -- Cheeeese
	"models/heroes/pudge/pudge.vmdl", -- Poodge
	"models/heroes/pangolier/pangolier.vmdl", -- Pango
	"models/heroes/bounty_hunter/bounty_hunter.vmdl", -- Bounty Hunter Statue
	"models/props_gameplay/treasure_chest_gold.vmdl", -- Bunch of gold from treasure
	"models/props/statues/priest/statue_priest.vmdl", -- lich statue
	"models/creeps/roshan/roshan.vmdl", -- Roshan
}

g_ParticlePrecache =
{
	-- cavern assets
	"particles/darkmoon_last_hit_effect.vpcf", --Last hit effect
	"particles/test_particle/ogre_melee_smash.vpcf", -- Ogres
	"particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", -- Pangoballers
	"particles/generic_gameplay/generic_slowed_cold.vpcf", -- Ghosts
	"particles/msg_fx/msg_bp.vpcf", -- bp reward effect
	"particles/generic_gameplay/battle_point_splash.vpcf", --bp reward effect
	"particles/npx_landslide_debris.vpcf", --Room destruction effect
	"particles/generic_gameplay/dropped_aegis.vpcf", -- Big Cheese
	"particles/cavern_player_deferred_light.vpcf", -- player light
	"particles/roshan_room_warninggoal.vpcf", -- in world roshan warning
	"particles/shop/shop_indicator_goal.vpcf", -- Shopkeeper
	
	-- dota assets
	"particles/units/heroes/hero_antimage/antimage_blade_hit.vpcf", 
	"particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", 
	"particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", 
	"particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", 
	"particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", -- Ogres
	"particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", -- treasure_chest
	"particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", -- treasure_chest's sunstrike trap
	"particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", -- treasure_chest's sunstrike trap
	"particles/dev/library/base_dust_hit.vpcf", -- modifier_destructible_gate
	"particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf", -- earthshaker
	"particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", -- Bounty Hunter Statue
	"particles/status_fx/status_effect_terrorblade_reflection.vpcf", -- Bounty Hunter Beacon Shrine
	"particles/status_fx/status_effect_burn.vpcf", -- Creature Invoker
	"particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf", -- room destruction
	"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf", -- room destruction
	"particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", --room destruction particle
	"particles/units/heroes/hero_lich/lich_chain_frost.vpcf", -- Chain frost trap
	"particles/units/heroes/hero_lich/lich_slowed_cold.vpcf",
	"particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", -- Creature Invoker
	"particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf", -- Creature Invoker
	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", -- Bounty Hunter Statue
	"particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", -- generic unit spawn 
	"particles/status_fx/status_effect_guardian_angel.vpcf", -- invuln on revive
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", --invuln on revive
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", --invuln on revive
}

g_ParticleFolderPrecache =
{
	"particles/units/heroes/hero_pugna", 	-- Pugna
	"particles/units/heroes/hero_sniper", 	-- Sniper
	"particles/units/heroes/hero_ogre_magi", -- Ogres
	"particles/units/heroes/hero_pudge", -- Pudge
	"particles/units/heroes/hero_pangolier", --Pangoliers
	"particles/units/heroes/hero_enigma", --Enigmaloiers
	"particles/units/heroes/hero_earthshaker", --Earthshakerliers
	"particles/units/heroes/hero_skeleton_king", -- Wraith Kings
}

g_SoundPrecache =
{
	-- cavern assets
	"soundevents/game_sounds_cavern.vsndevts",
	"soundevents/game_sounds_misc.vsndevts",
	
	-- dota assets
	"soundevents/game_sounds_items.vsndevts",

	"soundevents/voscripts/game_sounds_vo_antimage.vsndevts", -- AM
	"soundevents/voscripts/game_sounds_vo_lycan.vsndevts", -- Lycan
	"soundevents/voscripts/game_sounds_vo_ogre_magi.vsndevts", -- Ogres
	"soundevents/voscripts/game_sounds_vo_sniper.vsndevts", -- Sniper
	"soundevents/voscripts/game_sounds_vo_pugna.vsndevts", -- Pugna
	"soundevents/voscripts/game_sounds_vo_lich.vsndevts", -- Lich
	"soundevents/voscripts/game_sounds_vo_skeleton_king.vsndevts", -- Wraith King
	"soundevents/voscripts/game_sounds_vo_secretshop.vsndevts", -- Shopkeeper

	"soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", -- Techies
	"soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", -- AM
	"soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", -- Pudge
	"soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", -- Pangoballer
	"soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", -- Small Omni
	"soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", -- Enigmaloiers
	"soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", -- Earthshakerliers
	"soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", -- Big Pugna
	"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", -- Big Sniper
	"soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", -- Wraith King
	"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", -- Lich Trap
	"soundevents/game_sounds_roshan_halloween.vsndevts", -- Roshan
}
