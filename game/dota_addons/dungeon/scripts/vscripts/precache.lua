
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
		"models/gameplay/attrib_tome_int.vmdl",
		"models/gameplay/attrib_tome_agi.vmdl",
		"models/gameplay/attrib_tome_str.vmdl",
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

if GetMapName() == "ep_2" or GetMapName() == "ep_2_alt" then
	g_ItemPrecache =
	{
		"item_tombstone",
		"item_bag_of_gold",
		"item_health_potion",
		"item_mana_potion",
		"item_life_rune",
		--"item_orb_of_passage",
	}

	g_UnitPrecache =
	{
		"npc_treasure_chest",
		"npc_dota_creature_techies_land_mine", -- spawned by treasure_chest trap
		"npc_dota_crate",
		"npc_dota_vase",
		"npc_dota_temple_wisp",
		"npc_dota_creature_invoker",
		"npc_dota_creature_naga",
	}

	g_ModelPrecache =
	{
		"models/gameplay/attrib_tome_int.vmdl",
		"models/gameplay/attrib_tome_agi.vmdl",
		"models/gameplay/attrib_tome_str.vmdl",
		--"models/npc/npc_folks/townsfolk.vmdl",
		"models/gameplay/journalpaper.vmdl",
		"models/gameplay/wardenpaper.vmdl",
		"models/props_gameplay/treasure_chest001.vmdl",
		"models/gameplay/breakingcrate_dest.vmdl", -- npc_dota_crate
		"models/gameplay/breakingvase_dest.vmdl", -- npc_dota_vase
		"models/heroes/tuskarr/tuskarr.vmdl",
		"models/items/tuskarr/onizaphk_ahunter_weapon/onizaphk_ahunter_weapon.vmdl", -- elon tusk
		"models/items/tuskarr/onizaphk_ahunter_shoulder/onizaphk_ahunter_shoulder.vmdl", -- elon tusk
		"models/items/tuskarr/onizaphk_ahunter_neck/onizaphk_ahunter_neck.vmdl", -- elon tusk
		"models/items/tuskarr/onizaphk_ahunter_head/onizaphk_ahunter_head.vmdl", -- elon tusk
		"models/items/tuskarr/onizaphk_ahunter_back/onizaphk_ahunter_back.vmdl", -- elon tusk
		"models/items/tuskarr/onizaphk_ahunter_armsv2/onizaphk_ahunter_armsv2.vmdl", -- elon tusk
		"models/props_debris/camp_fire001.vmdl", -- plateau campfires
		"models/heroes/tuskarr/tuskarr_sigil.vmdl", -- undead_tusk_mage_tombstone
		"models/npc/npc_wisp/temple_wisp.vmdl",
		"models/heroes/monkey_king/transform_invisiblebox.vmdl", -- modifier_siltbreaker_bubble
		"models/props_gameplay/gold_coin001.vmdl", -- artifact coin
		"models/heroes/elder_titan/ancestral_spirit.vmdl", -- crypt wraith
		"models/courier/octopus/octopus_flying.vmdl", -- octopus at end of crypt_holdout
		"models/heroes/siren/siren.vmdl", -- npc_dota_creature_naga
		"models/items/siren/iceborn_armor/iceborn_armor.vmdl", -- npc_dota_creature_naga's wearable
		"models/items/siren/iceborn_head/iceborn_head.vmdl", -- npc_dota_creature_naga's wearable
		"models/heroes/undying/undying_tower.vmdl", -- npc_dota_creature_icy_tusk_skeleton
		"models/gameplay/prison_key.vmdl", -- gaoler
		"models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl", -- ice boss
		"models/creeps/darkreef/prisoner_swoledar/prisoner_swoledar04.vmdl", -- Siltbreaker summoned minion
	}

	g_ParticlePrecache =
	{
		"particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", -- treasure_chest
		"particles/darkmoon_last_hit_effect.vpcf",
		"particles/darkmoon_creep_warning.vpcf",
		"particles/test_particle/dungeon_generic_aoe.vpcf",
		"particles/fire_trap/trap_breathe_fire.vpcf", -- fire trap
		"particles/frostivus_gameplay/drow_linear_arrow.vpcf", -- drow
		"particles/frostivus_gameplay/drow_linear_frost_arrow.vpcf", -- drow
		"particles/frostivus_gameplay/legion_gladiators_ring.vpcf", -- LC's Gladiators Unite
		"particles/econ/generic/generic_buff_1.vpcf", -- Windranger Focus Fire?
		"particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf",
		"particles/generic_gameplay/generic_has_quest.vpcf",
		"particles/status_fx/status_effect_guardian_angel.vpcf", --invuln on respawn
		"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", --invuln on respawn
		"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", --invuln on respawn
		"particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", -- treasure_chest's sunstrike trap
		"particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", -- treasure_chest's sunstrike trap
		"particles/world_shrine/radiant_shrine_ambient.vpcf", -- npc_dota_goodguys_healers
        "particles/test_particle/dungeon_footsteps_sand.vpcf", -- footsteps
        "particles/msg_fx/msg_resist.vpcf",
        "particles/msg_fx/msg_resist_schinese.vpcf",
		"particles/test_particle/ogre_melee_smash.vpcf", -- ogre_seal_melee_smash
		"particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf", -- ogre_seal_flop
		"particles/units/heroes/hero_axe/axe_beserkers_call.vpcf", -- bear_roar, file has typo in it
        "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf", -- bear_cleave
        "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf",
		"particles/abilities/ice_breath.vpcf", -- creature_ice_breath
		"particles/units/heroes/hero_witchdoctor/witchdoctor_base_attack.vpcf", -- ice_giant ranged attack projectile
		"particles/act_2/ice_giant_projectile_gale.vpcf", -- ice_giant sheep projectile
		"particles/units/heroes/hero_lich/lich_chain_frost.vpcf", -- ice_giant chainfrost
		"particles/lycanboss_ruptureball_gale.vpcf", -- relict, ice_giant, frostbitten_ranged
		"particles/units/heroes/hero_lich/lich_frost_armor.vpcf", -- frostbitten_ranged_frost_armor
		"particles/units/heroes/hero_lich/lich_slowed_cold.vpcf", -- frostbitten_ranged_frost_armor
		"particles/status_fx/status_effect_frost_lich.vpcf", -- frostbitten_ranged_frost_armor
		"particles/status_fx/status_effect_frost_armor.vpcf", -- frostbitten_ranged_frost_armor
		"particles/act_2/frostbitten_shaman_projectile_gale.vpcf", -- frostbitten_shaman
		"particles/status_fx/status_effect_wyvern_arctic_burn.vpcf", -- freezing_blast
		"particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", -- freezing_blast
		"particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", -- relict_projectile
		--"particles/rain_fx/econ_snow.vpcf", -- ent_dota_lightinfo
		"particles/act_2/weather_plateau_snow.vpcf", -- ent_dota_lightinfo
		"particles/act_2/campfire_flame.vpcf", -- plateau campfires
		"particles/units/heroes/hero_treant/treant_overgrowth_trails.vpcf", -- snow treant invis pop stun
		"particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf",  -- snow treant invis pop stun
		"particles/generic_gameplay/generic_slowed_cold.vpcf", -- snow_pile
		"particles/status_fx/status_effect_frost.vpcf", -- snow_pile
		"particles/units/heroes/hero_puck/puck_illusory_orb.vpcf", -- ice boss
		"particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf", -- weather_snowstorm
		"particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf", -- weather_snowstorm_effect
		"particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift_buff.vpcf", -- campfire_effect
		"particles/addons_gameplay/player_deferred_light.vpcf", -- called by trigger in cave_crypt, attached to players
		"particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf", -- ice boss
		"particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", --storegga
		"particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", --creature_shadow_wave
		"particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf", -- creature_shadow_wave
		"particles/act_2/ice_giant_yak_explosion.vpcf", -- ice giant yak explosion
		"particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", -- ice_giant_hex
		"particles/lycanboss_ruptureball_gale.vpcf", -- ice_giant_hex
		"particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", -- Swoledar
		"particles/test_particle/dungeon_generic_blast_pre.vpcf", -- Siltbreaker
		"particles/test_particle/dungeon_generic_blast.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf", --  modifier_siltbreaker_immune_physical
		"particles/items_fx/ghost.vpcf", -- modifier_siltbreaker_immune_physical, modifier_item_glimmerdark_shield_prism
		"particles/items_fx/black_king_bar_avatar.vpcf", -- modifier_siltbreaker_immune_magical
		"particles/items2_fx/manta_phase.vpcf", -- Siltbreaker
		"particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", -- modifier_siltbreaker_summon_minions
		"particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", -- modifier_siltbreaker_mouth_beam
		"particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf", -- modifier_siltbreaker_mouth_beam
		"particles/units/heroes/hero_phoenix/phoenix_sunray_beam_enemy.vpcf", -- modifier_siltbreaker_mouth_beam
		--"particles/units/heroes/hero_slardar/slardar_sprint.vpcf", -- modifier_siltbreaker_sprint
		"particles/act_2/siltbreaker_sprint.vpcf", -- modifier_siltbreaker_sprint
		"particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", -- siltbreaker_waves
		"particles/act_2/siltbreaker_bubble.vpcf", -- modifier_siltbreaker_bubble
		"particles/econ/events/ti7/fountain_regen_ti7_bubbles.vpcf", -- modifier_siltbreaker_bubble
		"particles/act_2/siltbreaker_mind_control_shot.vpcf", -- siltbreaker_mind_control
		"particles/act_2/siltbreaker_line_wave_gale.vpcf", -- siltbreaker_line_wave
		"particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf", -- modifier_sand_king_boss_caustic_finale (Siltbreaker using it for now)
		"particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", -- amoeba
		"particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_dust_cauldron.vpcf", -- spike_trap
		"particles/act_2/spiketrap_anticipate.vpcf", -- spike_trap
		"particles/econ/events/darkmoon_2017/darkmoon_calldown_marker.vpcf", -- ogre_seal?
		"particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf", --amoeba
		"particles/act_2/wand_of_the_brine_bubble.vpcf", -- modifier_wand_of_the_brine_bubble
		"particles/units/heroes/hero_slardar/slardar_sprint.vpcf", -- modifier_slippers_of_the_abyss_sprint
		"particles/act_2/gleam.vpcf", -- modifier_item_glimmerdark_shield_prism
		"particles/status_fx/status_effect_ghost.vpcf", -- modifier_item_glimmerdark_shield_prism
		"particles/units/heroes/siltbreaker/siltbreaker_ambient.vpcf", --siltbreaker
		--"particles/status_fx/status_effect_bloodrage.vpcf", -- modifier_siltbreaker_mind_control
		"particles/units/heroes/siltbreaker/siltbreaker_ambient_stage2.vpcf", -- siltbreaker
		"particles/units/heroes/siltbreaker/siltbreaker_ambient_stage3.vpcf", -- siltbreaker
		"particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", -- swoledar_heal
		"particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", --amoeba
		"particles/camp_fire_buff.vpcf", -- campfire
		"particles/test_particle/generic_attack_crit_blur.vpcf", -- storegga
		"particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf",
	}

	g_ParticleFolderPrecache =
	{
		"particles/units/heroes/hero_winter_wyvern", -- Ice Boss
		"particles/units/heroes/hero_tusk", -- Ice Boss
		"particles/units/heroes/hero_batrider", -- Amoeba Temp fx
		"particles/units/heroes/hero_lone_druid", --Bears
		"particles/units/heroes/hero_ursa", --Bears
		"particles/units/heroes/hero_undying", --Crypt
		"particles/units/heroes/hero_slark", --Reefs Edge
		"particles/units/heroes/hero_razor", --Prison
		"particles/act_2",
	}

	g_SoundPrecache =
	{
		"soundevents/game_sounds_dungeon.vsndevts",
		"soundevents/game_sounds_dungeon_enemies.vsndevts",
		"soundevents/game_sounds_creeps.vsndevts",
		"soundevents/voscripts/game_sounds_vo_invoker.vsndevts", -- sunstrike
		"soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", -- Ice Boss
		"soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", -- Ice Boss
		"soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", 
		"soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", --Storegga
		"soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", --Bears
		"soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", --Bears
		"soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", --Crypt
		"soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", --Crypt
		"soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", 
		"soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", 
		"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", 
		"soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", 
		"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", 
		"soundevents/voscripts/game_sounds_vo_tiny.vsndevts", --storegga
		"soundevents/voscripts/game_sounds_vo_winter_wyvern.vsndevts", -- Ice Boss
		"soundevents/voscripts/game_sounds_vo_siltbreaker.vsndevts", -- Siltbreaker
		"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", -- Ice Giant, Frostbitten Shaman
	}
end

