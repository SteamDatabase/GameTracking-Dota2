
function InitialPrecache( context )
	print( "Preaching Holdout assets..." )

	-- General
	PrecacheItemByNameSync( "item_tombstone", context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheItemByNameSync( "item_health_potion", context )
	PrecacheItemByNameSync( "item_mana_potion", context )
	PrecacheItemByNameSync( "item_throw_snowball", context )
	PrecacheItemByNameSync( "item_summon_snowman", context )
	PrecacheItemByNameSync( "item_decorate_tree", context )
	PrecacheItemByNameSync( "item_festive_firework", context )
	PrecacheItemByNameSync( "item_ogre_seal_totem", context )

	PrecacheResource( "model", "models/props_structures/tower_good.vmdl", context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_last_hit_effect.vpcf", context )
	PrecacheResource( "particle", "particles/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/dropped_aegis.vpcf", context ) -- consumable gift drops	
	PrecacheResource( "particle", "particles/frostivus_gameplay/frostivus_ancient_destruction.vpcf", context )

	-- Custom Heroes
	PrecacheResource( "particle", "particles/player_heroes/dark_willow_shadow_realm_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_burn.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/kotl_chakra_burn_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
	PrecacheResource( "model", "models/items/witchdoctor/wd_ward/teller_of_the_auspice_ability/teller_of_the_auspice_ability.vmdl", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_winter_2018.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_greevils.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_return_buff.vpcf", context )

	-- Clinkz's Strafe
	PrecacheResource( "particle", "particles/player_heroes/clinkz_strafe_spill_attack.vpcf", context )

	-- Clinkz's Skeleton Walk
	PrecacheResource( "particle", "particles/player_heroes/clinkz_skeleton_walk_enemy_touched.vpcf", context )

	-- Round 1
	PrecacheUnitByNameSync( "npc_dota_pinecone_warrior", context )
	PrecacheUnitByNameSync( "npc_dota_pinecone_champion", context )

	-- Round 2
	PrecacheUnitByNameSync( "npc_dota_creature_tusk_skeleton", context )
	PrecacheUnitByNameSync( "npc_dota_creature_spectral_tusk_mage", context )
	PrecacheUnitByNameSync( "npc_dota_undead_tusk_tombstone", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_tombstone.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/undead_tusk_mage_sigil.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_tower_destruction.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/spectral_tusk_mage/spectral_tusk_mage_tower_destruction.vpcf", context )

	-- Round 3
	PrecacheUnitByNameSync( "npc_dota_creature_multiplying_eidelon", context )
	PrecacheUnitByNameSync( "npc_dota_creature_jakiro", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_jakiro", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_totem_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_totem_hero_effect.vpcf", context )

	-- Round 4
	PrecacheUnitByNameSync( "npc_dota_creature_small_ogre_seal", context )
	PrecacheUnitByNameSync( "npc_dota_creature_large_ogre_seal", context )
	PrecacheResource( "particle", "particles/creatures/ogre_seal/ogre_seal_warcry.vpcf", context )

	-- Round 5: Bonus
	PrecacheUnitByNameSync( "npc_dota_sled_penguin", context )
	PrecacheUnitByNameSync( "npc_dota_coin_pinata", context )
	PrecacheUnitByNameSync( "npc_dota_large_coin_pinata", context )
	PrecacheResource( "particle", "particles/coin_pinata_destroy.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_brewmaster_drunken_haze.vpcf", context )

	-- Round 6
	PrecacheResource( "particle", "particles/waves/infernal/invoker_forged_spirit_projectile_2.vpcf", context )
	PrecacheResource( "particle", "particles/waves/infernal/infernal_siege_fireball.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/doomling/impending_doom_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_doom", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context )
	PrecacheUnitByNameSync( "npc_dota_creature_forge_tank", context )
	PrecacheUnitByNameSync( "npc_dota_creature_doomling", context )
	PrecacheUnitByNameSync( "npc_dota_creature_doomling_champion", context )

	-- Round 7a
	PrecacheUnitByNameSync( "npc_dota_creature_broodmother", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_broodmother/broodmother_portrait.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_huge_broodmother", context )
	PrecacheUnitByNameSync( "npc_dota_creature_broodmother_baby", context )
	PrecacheUnitByNameSync( "npc_dota_creature_broodmother_baby_b", context )
	PrecacheUnitByNameSync( "npc_dota_creature_broodmother_baby_c", context )
	PrecacheUnitByNameSync( "npc_dota_creature_broodmother_baby_d", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_stickynapalm.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/broodmother/accrue_children_overhead_stack.vpcf", context )
	PrecacheResource( "particle", "particles/baby_brood_venom_pool.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", context )

	-- Round 8
	PrecacheUnitByNameSync( "npc_dota_creature_wolf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_medium_spectre", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/spectre/spectre_active_dispersion.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/spectre/spectre_damage_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/spectre/spectre_blademail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_base_attack_impact.vpcf", context )

	-- Round 9
	PrecacheUnitByNameSync( "npc_dota_creature_kobold_overboss", context )
	PrecacheUnitByNameSync( "npc_dota_creature_snowball_tuskar", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/creatures", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_preimage.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_slow.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/portrait_tusk.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/tusk_walruskick_tgt_status.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/tusk_walruskick_tgt.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/tusk_walruskick_txt_ult.vpcf", context )

	-- Round 10: Bonus
	PrecacheResource( "model", "models/creeps/ice_biome/merchant/elon_sled.vmdl", context )
	PrecacheResource( "particle", "particles/herder_sled.vpcf", context )

	-- Round 11 
	PrecacheUnitByNameSync( "npc_dota_creature_frostbitten_melee", context )
	PrecacheUnitByNameSync( "npc_dota_creature_large_elder_titan", context )
	PrecacheUnitByNameSync( "npc_dota_creature_medium_ancient_apparition", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_move.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined_detail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", context )


	-- Round 12
	PrecacheUnitByNameSync( "npc_dota_creature_storegga", context )
	PrecacheUnitByNameSync( "npc_dota_creature_medium_storegga", context )
	PrecacheUnitByNameSync( "npc_dota_creature_small_storegga", context )
	PrecacheUnitByNameSync( "npc_dota_storegga_rock", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_luna", context )
	PrecacheResource( "particle", "particles/act_2/storegga_spawn.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/storegga_channel.vpcf", context )

	-- Round 13
	PrecacheResource( "model", "models/items/storm_spirit/storm_spring_armor/storm_spring_armor.vmdl", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_stormspirit", context )
	PrecacheResource( "particle", "particles/creatures/mini_zeus/mini_zeus_lightning_preview.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )

	-- Round 14
	PrecacheUnitByNameSync( "npc_dota_creature_arc_warden_attacker", context )
	PrecacheUnitByNameSync( "npc_dota_creature_arc_warden_support", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_arc_warden.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_arc_warden", context )
	PrecacheResource( "particle", "particles/econ/items/puck/puck_alliance_set/puck_illusory_orb_aproset.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/test/fireball_machine_gun.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/test/fireball_machine_gun_building_impact_mechanical.vpcf", context )


	PrecacheResource( "particle_folder", "particles/units/heroes/hero_windrunner", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_rubick", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/keeper_of_the_light", context )
	PrecacheResource( "particle_folder", "particles/rubick_boss", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )

	PrecacheUnitByNameSync( "npc_dota_creature_rubick_melee_creep", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_boss_rubick", context, -1 )
	PrecacheResource( "particle", "particles/status_fx/status_effect_dark_seer_illusion.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_windrunner/windrunner_spell_powershot_rubick.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_rubick.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context )
	PrecacheResource( "model", "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/rubick_arcana/rubick_arcana_base.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/rubick_ti8_immortal_shoulders/rubick_ti8_immortal_shoulders.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/force_staff/force_staff.vmdl", context )
	PrecacheResource( "model", "models/heroes/rubick/shoulder.vmdl", context )
	PrecacheResource( "model", "models/heroes/rubick/rubick_head.vmdl", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_chaos_meteor_fly.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_thundergods_wrath.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_freezing_field_snow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_rain_of_chaos_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_rubick/rubick_rain_of_chaos.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_arcana/rubick_arc_spell_steal_default.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_lines.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_default.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_force_ambient/rubick_force_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_force_ambient/rubick_staff_ambient_kill.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_force.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_land_force.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_marker_force.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_arcana/rbck_arc_kunkka_ghost_ship.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_kunkka/kunkka_ghostship_marker.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/rubick/rubick_frosthaven_cube_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/rubick/rubick_frosthaven_spellsteal.vpcf", context )
end
