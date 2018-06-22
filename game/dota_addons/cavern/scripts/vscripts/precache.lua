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
	"npc_dota_creature_lich_statue",
	"npc_dota_creature_night_stalker",
	"npc_dota_pendulum_trap",
	"npc_dota_creature_pudge",
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
	"npc_dota_hero_undying",
	"npc_dota_lycan_wolf1",
	"npc_dota_lycan_wolf2",
	"npc_dota_lycan_wolf3",
	"npc_dota_lycan_wolf4",
}

g_ModelPrecache =
{
	-- dota assets
	"models/props_rock/riveredge_rock_wall003a.vmdl",
	"models/props_gameplay/cheese_01.vmdl", -- Cheeeese
	"models/props_gameplay/cheese_large.vmdl", -- Cheeeese
	"models/props_gameplay/treasure_chest_gold.vmdl", -- Bunch of gold from treasure
	"models/heroes/lycan/lycan_wolf.vmdl",
	"models/creeps/neutral_creeps/n_creep_forest_trolls/n_creep_forest_troll_berserker.vmdl",
	"models/creeps/neutral_creeps/n_creep_golem_a/n_creep_golem_a.vmdl",
	"models/creeps/neutral_creeps/n_creep_golem_b/n_creep_golem_b.vmdl",
	"models/creeps/neutral_creeps/n_creep_ghost_b/n_creep_ghost_b.vmdl",
	"dota/models/heroes/lycan/lycan_wolf.vmdl",
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

	-- dota standard precache we need
	"particles/dire_fx/dire_building_damage_major.vpcf",
	"particles/dire_fx/dire_building_damage_minor.vpcf",
	"particles/base_attacks/ranged_tower_bad_linear.vpcf",
	"particles/world_destruction_fx/tree_destroy.vpcf",
	"particles/base_attacks/ranged_badguy.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_blur.vpcf",	
	
	-- dota assets	
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
	"particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", -- generic unit spawn 
	"particles/status_fx/status_effect_guardian_angel.vpcf", -- invuln on revive
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", --invuln on revive
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", --invuln on revive

	"particles/units/heroes/hero_antimage/antimage_blade_hit.vpcf", 
	"particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", 
	"particles/units/heroes/hero_antimage/antimage_blink_end.vpcf", 
	"particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", 

	"particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf",

	"particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
	"particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf",
	"particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf",
	"particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf",
	"particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf",

	"particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf",
	"particles/units/heroes/hero_sniper/sniper_headshot_slow_caster.vpcf",

	"particles/units/heroes/hero_pugna/pugna_decrepify.vpcf",
	"particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf",
 	"particles/units/heroes/hero_pugna/pugna_netherblast.vpcf",
 	"particles/units/heroes/hero_pugna/pugna_life_drain.vpcf",

 	"particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf",
	"particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf",
	"particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf",
	"particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf",
	"particles/units/heroes/hero_lycan/lycan_shapeshift_buff_speed.vpcf",
	"particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf",
	"particles/units/heroes/hero_lycan/lycan_shapeshift_portrait.vpcf",
	"particles/units/heroes/hero_lycan/lycan_claw_blur_b.vpcf",
	"particles/units/heroes/hero_lycan/lycan_claw_blur.vpcf",
	"particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf",
	"particles/units/heroes/hero_lycan/lycan_shapeshift_death_fwd.vpcf",

	"particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_totem_hero_effect.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_totem_cast.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_totem_blur_impact.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
	"particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf",

	"particles/units/heroes/hero_dark_willow/dark_willow_bramble_cast.vpcf",
	"particles/units/heroes/hero_dark_willow/dark_willow_bramble_precast.vpcf",
	"particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith.vpcf",
	"particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf",

	"particles/units/heroes/hero_pangolier/pangolier_gyroshell_cast.vpcf",
	"particles/units/heroes/hero_pangolier/pangolier_gyroshell.vpcf",
	"particles/units/heroes/hero_pangolier/pangolier_gyroshell_jump_trail.vpcf",
	"particles/units/heroes/hero_pangolier/pangolier_loadout.vpcf",
	"particles/units/heroes/hero_life_stealer/life_stealer_open_wounds_impact.vpcf",
	"particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf",
	"particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf",
}


g_ParticleFolderPrecache =
{
}

g_SoundPrecache =
{
	-- cavern assets
	"soundevents/game_sounds_cavern.vsndevts",
	"soundevents/game_sounds_misc.vsndevts",

	"soundevents/game_sounds/game_sounds_creature_techies.vsndevts",
	"soundevents/game_sounds/game_sounds_hud_roshan.vsndevts",
}
