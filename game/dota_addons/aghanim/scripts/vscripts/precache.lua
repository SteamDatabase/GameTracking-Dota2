g_ItemPrecache =
{
	"item_tombstone",
	"item_bag_of_gold",
	"item_health_potion",
	"item_mana_potion",
	"item_life_rune",
	"item_battle_points",
	"item_arcane_fragments",
	"item_javelin",
	"item_monkey_king_bar",
	"item_cursed_item_slot",
	"item_cursed_key",
}

g_UnitPrecache =
{
	-- YOU THERE!!!! YES, YOU!!!!!!!
	-- Don't put your precaches in here. Units will already be precached by dota spawners
	-- Put your other precache in Precache methods in your encounters, ai, or abilities
	-- whether they are in script or C++ code.
	-- Doing so means quicker load time and less total memory used

	-- Assets in Aghanim path
	"npc_treasure_chest",
	"npc_dota_explosive_barrel",
	"aghsfort_ascension_level_picker_1",
	"aghsfort_ascension_level_picker_2",
	"aghsfort_ascension_level_picker_3",
	"aghsfort_ascension_level_picker_4",
	"npc_dota_announcer_aghanim",
	"npc_dota_story_crystal",
	"npc_dota_creature_event_life_roshan",
	"npc_dota_creature_shard_shop_oracle",
	-- Assets in Dota path
}

g_ModelPrecache =
{
	-- YOU THERE!!!! YES, YOU!!!!!!!
	-- Don't put your precaches in here. Units will already be precached by dota spawners
	-- Put your other precache in Precache methods in your encounters, ai, or abilities
	-- whether they are in script or C++ code.
	-- Doing so means quicker load time and less total memory used
	"models/gameplay/breakingcrate_dest.vmdl", -- item_bag_of_gold
	--"models/gameplay/attrib_tome_str.vmdl", -- item_book_of_strength
	--"models/gameplay/attrib_tome_agi.vmdl", -- item_book_of_agility
	--"models/gameplay/attrib_tome_int.vmdl", -- item_book_of_intelligence

	-- Assets in Dota path
	"models/props_gameplay/treasure_chest_gold.vmdl", -- Bunch of gold from treasure
	"models/props_gameplay/treasure_chest001.vmdl", -- Netural item chests
	"models/props_gameplay/gold_bag.vmdl", -- item_bag_of_gold
	"models/ui/exclamation/questionmark.vmdl", -- hidden challenges
	"models/heroes/bristleback/bristleback_back.vmdl",
	"models/heroes/bristleback/bristleback_bracer.vmdl",
	"models/heroes/bristleback/bristleback_head.vmdl", 
	"models/heroes/bristleback/bristleback_necklace.vmdl", 
	"models/heroes/bristleback/bristleback_weapon.vmdl", 
	"models/heroes/aghanim/aghanim_model.vmdl", 
}

g_ParticlePrecache =
{
	-- YOU THERE!!!! YES, YOU!!!!!!!
	-- Don't put your precaches in here. Units will already be precached by dota spawners
	-- Put your other precache in Precache methods in your encounters, ai, or abilities
	-- whether they are in script or C++ code.
	-- Doing so means quicker load time and less total memory unsed

	-- Assets in Aghanim path
	"particles/dark_moon/darkmoon_last_hit_effect.vpcf", -- Last hit effect
	"particles/dark_moon/darkmoon_creep_warning.vpcf", -- used in many places to warn about an attack
	"particles/forest/crate_destruction.vpcf", -- crate
	"particles/forest/vase_destruction.vpcf", -- vase

	-- Blessings
	"particles/blessings/death_detonation/death_detonation_remote_mines_detonate.vpcf",

	-- Assets in Dota path
	"particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", -- dark portal fx
	"particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", -- dark portal fx
	"particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf", -- dark portal fx
	"particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", -- fx for test_encounter concommand
	"particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", -- fx for battle royale
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", -- Used by modifier_omninight_guardian_angel, for player respawn
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf", -- Used by modifier_omninight_guardian_angel, for player respawn
	"particles/status_fx/status_effect_guardian_angel.vpcf", -- Used by modifier_omninight_guardian_angel, for player respawn
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", -- Used by modifier_omninight_guardian_angel, for player respawn
	"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", -- Used by modifier_omninight_guardian_angel, for player respawn
	"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", -- used by modifier_enrage
	"particles/items5_fx/neutral_treasurebox.vpcf", -- neutral item drop
	"particles/items5_fx/neutral_treasurebox_lvl0.vpcf", -- neutral item drop
	"particles/items5_fx/neutral_treasurebox_lvl1.vpcf", -- neutral item drop
	"particles/items5_fx/neutral_treasurebox_lvl2.vpcf", -- neutral item drop
	"particles/items5_fx/neutral_treasurebox_lvl3.vpcf", -- neutral item drop
	"particles/items5_fx/neutral_treasurebox_lvl4.vpcf", -- neutral item drop
	"particles/neutral_fx/neutral_item_drop_lvl0.vpcf", -- neutral item drop
	"particles/neutral_fx/neutral_item_drop_lvl1.vpcf", -- neutral item drop
	"particles/neutral_fx/neutral_item_drop_lvl2.vpcf", -- neutral item drop
	"particles/neutral_fx/neutral_item_drop_lvl3.vpcf", -- neutral item drop
	"particles/neutral_fx/neutral_item_drop_lvl4.vpcf", -- neutral item drop
	"particles/neutral_fx/neutral_item_drop_lvl5.vpcf", -- neutral item drop
	"particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", -- treasure chest surprise
	"particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf",
	"particles/creature_true_sight.vpcf", -- modifier_detect_invisible
	"particles/msg_fx/msg_bp.vpcf",
	"particles/generic_gameplay/battle_point_splash.vpcf",
	"particles/gameplay/hero_ground_light.vpcf",
	"particles/generic_gameplay/dust_impact.vpcf",
	"particles/units/heroes/hero_oracle/oracle_idle_throw.vpcf",
	"particles/generic_gameplay/dust_impact_large.vpcf",
	"particles/units/heroes/hero_oracle/oracle_ambient_head.vpcf",
}

g_SoundPrecache =
{
	-- Assets in Aghanim path
	"soundevents/game_sounds_aghanim.vsndevts",
	"soundevents/game_sounds_dungeon.vsndevts",
	"soundevents/game_sounds_aghanim_creatures.vsndevts",
	"soundevents/game_sounds_dungeon_enemies.vsndevts",
	"soundevents/game_sounds_pudge_miniboss.vsndevts",

	-- Assets in Dota path
	"soundevents/voscripts/game_sounds_vo_meepo.vsndevts",
	"soundevents/voscripts/game_sounds_vo_bristleback.vsndevts",
	"soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", -- dark portal sounds
}
