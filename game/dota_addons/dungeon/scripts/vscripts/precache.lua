if GetMapName() == "ep_1" then
	g_ItemPrecache =
	{
		"item_tombstone",
		"item_bag_of_gold",
		"item_health_potion",
		"item_mana_potion",
		"item_life_rune",
		"item_orb_of_passage",
	}

	g_UnitPrecache =
	{
		"npc_treasure_chest",
		"npc_dota_creature_techies_land_mine", -- spawned by treasure_chest trap
		"npc_dota_crate",
		"npc_dota_vase",
		"npc_dota_friendly_bristleback",
		"npc_dota_friendly_bristleback_son",
		"npc_dota_temple_wisp",
		"npc_dota_creature_invoker",
	}

	g_ModelPrecache =
	{
		"models/items/lycan/wolves/ambry_summon/ambry_summon.vmdl",
		"models/heroes/nerubian_assassin/mound.vmdl", -- Giant Burrower
		"models/items/nerubian_assassin/cursed_zealot_head/cursed_zealot_head.vmdl", -- Giant Burrower
		"models/items/nerubian_assassin/cursed_zealot_weapon/cursed_zealot_weapon.vmdl", -- Giant Burrower
		"models/items/nerubian_assassin/cursed_zealot_back/cursed_zealot_back.vmdl", -- Giant Burrower
		"models/items/nerubian_assassin/cursed_zealot_misc/cursed_zealot_misc.vmdl", -- Giant Burrower
		"models/items/broodmother/spiderling/lycosidae_spiderling/lycosidae_spiderling.vmdl", -- ability: larval_parasite
		"models/items/nerubian_assassin/cursed_zealot_weapon/cursed_zealot_weapon.vmdl",
		"models/npc/npc_dingus/dingus.vmdl",
		"models/npc/npc_folks/townsfolk.vmdl",
		"models/gameplay/journalpaper.vmdl",
		"models/props_gameplay/treasure_chest001.vmdl",
		"models/gameplay/breakingcrate_dest.vmdl", -- npc_dota_crate
		"models/gameplay/breakingvase_dest.vmdl", -- npc_dota_vase
		"models/items/mirana/crescent_arrow/crescent_arrow.vmdl", -- used by bandit_archer_arrow's particle (particles/dungeon_bandit_archer_crescent_arrow.vpcf) and probably stone_trap's
		"models/creeps/knoll_1/werewolf_boss.vmdl",
		"models/creeps/ogre_1/ogre_web.vmdl", -- npc_dota_creature_friendly_ogre_webbed
	}

	g_ParticlePrecache =
	{
		"particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", -- treasure_chest
		"particles/darkmoon_last_hit_effect.vpcf",
		"particles/darkmoon_creep_warning.vpcf",
		"particles/fire_trap/trap_breathe_fire.vpcf",
		"particles/frostivus_gameplay/drow_linear_arrow.vpcf",
		"particles/frostivus_gameplay/drow_linear_frost_arrow.vpcf",
		"particles/test_particle/ogre_melee_smash.vpcf",
		"particles/test_particle/test_model_cluster_linear_projectile.vpcf",
		"particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf",
		"particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
		"particles/units/heroes/hero_broodmother/broodmother_web.vpcf",
		"particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", -- bat_acid_launch
		"particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", -- bat_acid_launch
		"particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", -- bat_acid_launch
		"particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile_linear.vpcf", -- bat_acid_launch
		"particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf",
		"particles/traps/temple_trap_arrow.vpcf",
		"particles/test_particle/omniknight_wildaxe.vpcf",
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf", -- Stifling Dagger NB_2017
		"particles/phantom_assassin_linear_dagger.vpcf", -- Stifling Dagger NB_2017
		"particles/units/heroes/hero_riki/riki_blink_strike.vpcf", -- creature_blink_strike
		"particles/frostivus_gameplay/legion_gladiators_ring.vpcf", -- Gladiators Unite
		"particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf", -- Kidnap Spider: Flaming Lasso
		"particles/units/heroes/hero_beastmaster/beastmaster_wildaxes_hit.vpcf", -- Temple Guardian Hammer Throw
		"particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf",
		"particles/econ/generic/generic_buff_1.vpcf", -- Windranger Focus Fire?
		"particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", -- giant_burrower_minion_spawner
		"particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf",
		"particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf",
		"particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses_body.vpcf",
		"particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf",
		"particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
		"particles/units/heroes/hero_meepo/meepo_earthbind.vpcf", -- dunerunner_earthbind
		"particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", -- centaur_shaman_ranged_attack
		"particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_web_cast.vpcf", -- spider_boss_larval_parasite
		"particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf", -- spider_boss_larval_parasite
		"particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", -- larval_parasite
		"particles/dungeon_overhead_timer.vpcf", -- larval_parasite
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf",
		"particles/generic_gameplay/generic_has_quest.vpcf",
		"particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
		"particles/base_attacks/ranged_tower_good_linear.vpcf",
		"particles/base_attacks/ranged_tower_bad_linear.vpcf",
		"particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", 
		"particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf",
		"particles/lycanboss_ruptureball_gale.vpcf", --lycanboss_ruptureball_gale
		"particles/econ/generic/generic_projectile_linear_1/generic_projectile_linear_1.vpcf",
		"particles/test_particle/generic_attack_crit_blur.vpcf",
		"particles/test_particle/generic_attack_charge.vpcf",
		"particles/test_particle/generic_attack_crit_blur_shapeshift.vpcf",
		"particles/dungeon_bandit_archer_crescent_arrow.vpcf", -- bandit_archer_arrow
		"particles/test_particle/dungeon_pugna_blast.vpcf", -- temple_guardian
		"particles/test_particle/dungeon_pugna_blast_pre.vpcf", -- temple_guardian
		"particles/status_fx/status_effect_guardian_angel.vpcf", --invuln on respawn
		"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", --invuln on respawn
		"particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf", -- ghost_terror
		"particles/units/heroes/hero_bane/bane_fiends_grip.vpcf", -- ghost_terror
		"particles/test_particle/sand_king_cyclone.vpcf", 
		"particles/test_particle/dungeon_sand_king_channel.vpcf", 
		"particles/test_particle/dungeon_sand_king_blocker.vpcf", 
		"particles/test_particle/sandking_burrowstrike_no_models.vpcf",
		"particles/test_particle/sand_king_projectile.vpcf",
		"particles/test_particle/dungeon_broodmother_linear.vpcf", -- npc_dota_goodguys_healers
		"particles/test_particle/dungeon_generic_aoe.vpcf",
		"particles/test_particle/dungeon_broodmother_debuff_explode.vpcf",
		"particles/test_particle/dungeon_debuff_webs.vpcf",
		"particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf",
		"particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_physical.vpcf",
		"particles/generic_gameplay/generic_lifesteal.vpcf", -- spider_boss_rage
		"particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", -- treasure_chest's sunstrike trap
		"particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", -- treasure_chest's sunstrike trap
		"particles/test_particle/dungeon_generic_blast_pre.vpcf",
		"particles/test_particle/dungeon_generic_blast.vpcf",
		"particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf",
		"particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf",
		"particles/status_fx/status_effect_medusa_stone_gaze.vpcf",
		"particles/units/heroes/hero_medusa/medusa_stone_gaze_cast.vpcf",
		"particles/world_shrine/radiant_shrine_ambient.vpcf", -- npc_dota_goodguys_healers
		"particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf",
		"particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf",
		"particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf",
		"particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", --assault_captain_sun_ray
		"particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf", --assault_captain_sun_ray
		"particles/units/heroes/hero_phoenix/phoenix_sunray_beam_enemy.vpcf", --assault_captain_sun_ray
		"particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", -- assault_captain_searing_chains
		"particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", -- assault_captain_searing_chains
		"particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", -- assault_captain_searing_chains
        "particles/test_particle/dungeon_footsteps_sand.vpcf", -- footsteps
        "particles/msg_fx/msg_resist.vpcf",
        "particles/msg_fx/msg_resist_schinese.vpcf",
	}

	g_ParticleFolderPrecache =
	{
		
		"particles/units/heroes/hero_lycan", -- Lycan Boss
		"particles/units/heroes/hero_bloodseeker",
		"particles/units/heroes/hero_axe",
		"particles/units/heroes/hero_pugna", 	-- Ogres
		"particles/units/heroes/hero_ogre_magi",
		"particles/units/heroes/hero_venomancer", -- Spiders
		"particles/units/heroes/hero_broodmother",
		"particles/units/heroes/hero_omniknight", -- Temple Guardian
		"particles/units/heroes/hero_skywrath_mage",
		"particles/units/heroes/hero_nyx_assassin",  -- Burrowers
		"particles/units/heroes/hero_centaur",  -- Centaurs
		"particles/units/heroes/hero_sandking", -- Sand King
	}

	g_SoundPrecache =
	{
		"soundevents/game_sounds_dungeon.vsndevts",
		"soundevents/game_sounds_dungeon_enemies.vsndevts",
		"soundevents/game_sounds_creeps.vsndevts",
		"soundevents/voscripts/game_sounds_vo_lycan.vsndevts",
		"soundevents/voscripts/game_sounds_vo_sandking.vsndevts",
		"soundevents/voscripts/game_sounds_vo_ogre_magi.vsndevts",
		"soundevents/voscripts/game_sounds_vo_broodmother.vsndevts",
		"soundevents/voscripts/game_sounds_vo_invoker.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts",
		"soundevents/game_sounds_roshan_halloween.vsndevts", 
		"soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts",
		"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", -- assault_captain
		"soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", -- assault_captain
	}
end

