g_ItemPrecache =
{
	"item_candy",
	"item_candy_bag",
	"item_health_potion",
	"item_mana_potion",
	"item_bag_of_gold",
}

g_UnitPrecache =
{
	"npc_dota_roshan_diretide",
	"npc_dota_creature_zombie_ogreseal",
	"npc_dota_creature_zombie_basic",
	"npc_dota_creature_zombie_torso",
	"npc_dota_creature_skeleton",
	"npc_dota_creature_dark_troll_warlord",
	"npc_dota_creature_visage_familiar1",
	"npc_dota_creature_hulk_radiant",
	"npc_dota_creature_hulk_dire",
	"candy_bucket",
	"neutral_candy_bucket",
	"npc_dota_diretide_portal",
	"npc_dota_radiant_bucket_soldier",
	"npc_dota_dire_bucket_soldier",
	"npc_dota_neutral_bucket_soldier",
	"npc_dota_creature_ranged_ghost",
	"npc_dota_creature_melee_ghost",
	"npc_dota_creature_huge_broodmother",
	"npc_dota_creature_newborn_spider",
	"npc_dota_announcer_diretide",
	"npc_dota_greevil",
	"npc_dota_greevil_leader",
}

g_ModelPrecache =
{
	"models/props_gameplay/pumpkin_bucket.vmdl",
	"models/props_tree/mango_tree.vmdl",

	"models/props_gameplay/rune_doubledamage01.vmdl",
	"models/props_gameplay/rune_haste01.vmdl",
	"models/props_gameplay/rune_illusion01.vmdl",
	"models/props_gameplay/rune_invisibility01.vmdl",
	"models/props_gameplay/rune_regeneration01.vmdl",
	"models/props_gameplay/rune_goldxp.vmdl",
	"models/props_gameplay/rune_arcane.vmdl",

	"models/diretide_intro_sky_dome.vmdl",
	"models/diretide_intro_sky_dome_expand.vmdl",

	"models/events/frostivus/penguin/penguin_prime.vmdl",
	"models/creeps/ice_biome/snowball/snowball.vmdl",
	"models/creeps/ice_biome/ogreseal/ogreseal_rednose.vmdl",
	"models/props_gameplay/cold_frog.vmdl",
}

g_ParticlePrecache =
{
	"particles/econ/generic/generic_progress_meter/generic_progress_circle.vpcf",
	"particles/neutral_fx/skeleton_spawn.vpcf", -- creature_dark_troll_warlord
	"particles/creeps/lane_creeps/creep_dire_hulk_swipe_right.vpcf", -- bucket soldier
	"particles/creeps/lane_creeps/creep_dire_hulk_swipe_left.vpcf", -- bucket soldier
	"particles/creeps/lane_creeps/creep_radiant_hulk_swipe_left.vpcf", -- bucket soldier
	"particles/creeps/lane_creeps/creep_radiant_hulk_swipe_right.vpcf", -- bucket soldier
	"particles/status_fx/status_effect_diretide_hulk.vpcf", -- bucket soldier
	"particles/hw_fx/hw_candy_drop.vpcf",
	"particles/hw_fx/candy_well_idle.vpcf", -- candy well idle
	"particles/candy/candy_xp_gain.vpcf",
	"particles/creature_true_sight.vpcf", -- modifier_detect_invisible
	"particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", -- used by bucket soldiers
	"particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", -- used by Roshan knockback
	"particles/units/heroes/hero_pangolier/pangolier_gyroshell_jump_trail.vpcf", -- used by Roshan knockback
	"particles/dark_moon/darkmoon_last_hit_effect.vpcf", -- when killing creature (diretide_events)
	"particles/destruction/candy_well_destruction.vpcf", -- temp candy well destruction (diretide_events)
	"particles/destruction/candy_drop_destruction.vpcf", -- ditto but for the neutral bucket
	"particles/roshan/roshan_curse/roshan_curse_debuff.vpcf", -- roshan
	"particles/roshan/roshan_curse/roshan_curse_debuff_screen.vpcf", -- roshan
	"particles/roshan/roshan_curse/roshan_chase_screen.vpcf", -- roshan
	"particles/econ/items/ursa/ursa_ti10/ursa_ti10_earthshock.vpcf", -- roshan
	"particles/roshan/target_hero_shield.vpcf", -- roshan's target
	"particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", -- map candy buckets
	"particles/neutral_fx/neutral_item_drop_lvl4.vpcf", -- neutral item drop
	"particles/scarecrow/scarecrow_damaged.vpcf", -- neutral_candy_bucket
	"particles/candy/candy_bucket_tier_0.vpcf", -- candy bucket
	"particles/candy/candy_bucket_tier_1.vpcf", -- candy bucket
	"particles/candy/candy_bucket_tier_2.vpcf", -- candy bucket
	"particles/candy/candy_bucket_tier_3.vpcf", -- candy bucket
	"particles/candy/candy_shield.vpcf", -- item_candy_shield
	"particles/units/greevils/greevil_blood.vpcf", -- Greevil blood
	"particles/units/greevils/greevil_blood_spit.vpcf", -- Greevil blood spit
	"particles/units/greevils/greevil_blood_death.vpcf",	-- Greevil blood death

	"particles/generic_gameplay/rune_doubledamage.vpcf",
	"particles/generic_gameplay/rune_haste.vpcf",
	"particles/generic_gameplay/rune_illusion.vpcf",
	"particles/generic_gameplay/rune_invisibility.vpcf",
	"particles/generic_gameplay/rune_regeneration.vpcf",
	"particles/generic_gameplay/rune_arcane.vpcf",
	"particles/generic_gameplay/rune_bounty.vpcf",
	"particles/generic_gameplay/rune_bounty_first.vpcf",
	"particles/generic_gameplay/rune_bounty_prespawn.vpcf",

	"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf",

	-- Mounts
	"particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf", -- crash
	"particles/status_fx/status_effect_brewmaster_drunken_haze.vpcf", -- crash
	"particles/units/mounts/mount_land_impact.vpcf",
	"particles/units/mounts/mount_penguin_impact.vpcf",
	"particles/units/mounts/mount_snowball_impact.vpcf",
	"particles/units/mounts/mount_ogreseal_impact.vpcf",
	"particles/units/mounts/mount_frosttoad_impact.vpcf",
	"particles/hw_fx/mount_snowball_impact.vpcf",
	"particles/hw_fx/mount_max_speed.vpcf",
	"particles/hw_fx/snowball_summon_aoe_snow.vpcf",
	"particles/hw_fx/mount_summon.vpcf",
	"particles/units/mounts/mount_frosttoad_summon.vpcf",

}

g_ParticleFolderPrecache =
{
	"particles/units/heroes/hero_undying",
	"particles/units/heroes/hero_clinkz",
	"particles/units/heroes/hero_warlock",
}

g_SoundPrecache =
{
	-- Assets in Winter2022 path
	"soundevents/game_sounds_winter2022.vsndevts",

	-- Assets in Dota path
	"soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", -- zombies
	"soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", -- skeletons
	"soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", -- mounts
	"soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", -- mounts
	"soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", -- mounts
	"soundevents/game_sounds_roshan_halloween.vsndevts", --roshan
}
