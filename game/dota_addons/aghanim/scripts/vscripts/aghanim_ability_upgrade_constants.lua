LinkLuaModifier( "modifier_minor_ability_upgrades", "modifiers/modifier_minor_ability_upgrades", LUA_MODIFIER_MOTION_NONE )

_G.MINOR_ABILITY_UPGRADE_OP_ADD = 1
_G.MINOR_ABILITY_UPGRADE_OP_MUL = 2

_G.MINOR_ABILITY_COOLDOWN_MANACOST_PCT = 7

_G.MINOR_ABILITY_UPGRADES =
{
   npc_dota_hero_magnataur = require( "minor_ability_upgrades/minor_ability_upgrades_magnataur" ),
   npc_dota_hero_phantom_assassin = require( "minor_ability_upgrades/minor_ability_upgrades_phantom_assassin" ),
   npc_dota_hero_snapfire = require( "minor_ability_upgrades/minor_ability_upgrades_snapfire" ),
   npc_dota_hero_disruptor = require( "minor_ability_upgrades/minor_ability_upgrades_disruptor" ),
   npc_dota_hero_winter_wyvern = require( "minor_ability_upgrades/minor_ability_upgrades_winter_wyvern" ),
   npc_dota_hero_tusk = require( "minor_ability_upgrades/minor_ability_upgrades_tusk" ),
   npc_dota_hero_ursa = require( "minor_ability_upgrades/minor_ability_upgrades_ursa" ),
   npc_dota_hero_sniper = require( "minor_ability_upgrades/minor_ability_upgrades_sniper" ),
   npc_dota_hero_mars = require( "minor_ability_upgrades/minor_ability_upgrades_mars" ),
   npc_dota_hero_viper = require( "minor_ability_upgrades/minor_ability_upgrades_viper" ),
   npc_dota_hero_weaver = require( "minor_ability_upgrades/minor_ability_upgrades_weaver" ),
   npc_dota_hero_omniknight = require( "minor_ability_upgrades/minor_ability_upgrades_omniknight" ),
   npc_dota_hero_witch_doctor = require( "minor_ability_upgrades/minor_ability_upgrades_witch_doctor" ),
   npc_dota_hero_templar_assassin = require( "minor_ability_upgrades/minor_ability_upgrades_templar_assassin" ),
   npc_dota_hero_slark = require( "minor_ability_upgrades/minor_ability_upgrades_slark" ),
   npc_dota_hero_queenofpain = require( "minor_ability_upgrades/minor_ability_upgrades_queenofpain" ),
   npc_dota_hero_undying = require( "minor_ability_upgrades/minor_ability_upgrades_undying" ),
   npc_dota_hero_juggernaut = require( "minor_ability_upgrades/minor_ability_upgrades_juggernaut" ),
   npc_dota_hero_drow_ranger = require( "minor_ability_upgrades/minor_ability_upgrades_drow_ranger" ),
   npc_dota_hero_luna = require( "minor_ability_upgrades/minor_ability_upgrades_luna" ),
   npc_dota_hero_void_spirit = require( "minor_ability_upgrades/minor_ability_upgrades_void_spirit" ),
   npc_dota_hero_lich = require( "minor_ability_upgrades/minor_ability_upgrades_lich" ),
   npc_dota_hero_lina = require( "minor_ability_upgrades/minor_ability_upgrades_lina" ),
   npc_dota_hero_gyrocopter = require( "minor_ability_upgrades/minor_ability_upgrades_gyrocopter" ),
   npc_dota_hero_dawnbreaker = require( "minor_ability_upgrades/minor_ability_upgrades_dawnbreaker" ),
   npc_dota_hero_bane = require( "minor_ability_upgrades/minor_ability_upgrades_bane" ),
   npc_dota_hero_phoenix = require( "minor_ability_upgrades/minor_ability_upgrades_phoenix" ),
   npc_dota_hero_kunkka = require( "minor_ability_upgrades/minor_ability_upgrades_kunkka" ),
   npc_dota_hero_sand_king = require( "minor_ability_upgrades/minor_ability_upgrades_sand_king" ),
   npc_dota_hero_clinkz = require( "minor_ability_upgrades/minor_ability_upgrades_clinkz" ),
   --non hero specific upgrades (bonus HP/mana/damage/etc.)
   base_stats_upgrades = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
}

_G.STAT_UPGRADE_EXCLUDES =
{
   npc_dota_hero_omniknight =
   {
      "aghsfort_minor_stat_upgrade_bonus_attack_speed",
   },

   npc_dota_hero_magnataur = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },
   
   npc_dota_hero_winter_wyvern = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_disruptor =
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_snapfire = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_tusk = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },

   npc_dota_hero_ursa = 
   {
      "aghsfort_minor_stat_upgrade_bonus_spell_amp",
   },

   npc_dota_hero_sniper = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_mars = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },

   npc_dota_hero_viper = 
   {
      "aghsfort_minor_stat_upgrade_bonus_magic_resist",
   },

   npc_dota_hero_weaver = 
   {
      "aghsfort_minor_stat_upgrade_bonus_spell_amp",
   },

   npc_dota_hero_witch_doctor = 
   {
      "aghsfort_minor_stat_upgrade_bonus_attack_damage",
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_queenofpain = 
   {
   },

   npc_dota_hero_templar_assassin = 
   {
   },

   npc_dota_hero_slark = 
   {
   },

   npc_dota_hero_lich =
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_luna =
   {
   },

   npc_dota_hero_kunkka = 
   {
   },

   npc_dota_hero_undying = 
   {
   },

   npc_dota_hero_juggernaut =
   {
   },

   npc_dota_hero_drow_ranger =
   {
   },

   npc_dota_hero_void_spirit = 
   {
   },
   npc_dota_hero_lina = 
   {
   },   
   npc_dota_hero_gyrocopter = 
   {
   }, 
   npc_dota_hero_dawnbreaker = 
   {
   }, 

   npc_dota_hero_bane = 
   {
   },      

   npc_dota_hero_phoenix = 
   {
   },

   npc_dota_hero_sand_king = 
   {
   },

   npc_dota_hero_clinkz = 
   {
   },
}

-- NOTE: These are substrings to search for in SPECIAL_ABILITY_UPGRADES
_G.ULTIMATE_ABILITY_NAMES =
{
   npc_dota_hero_omniknight = "omniknight_guardian_angel",
   npc_dota_hero_magnataur = "magnataur_reverse_polarity",
   npc_dota_hero_phantom_assassin = "phantom_assassin_coup_de_grace",
   npc_dota_hero_winter_wyvern = "winter_wyvern_winters_curse",
   npc_dota_hero_disruptor = "disruptor_static_storm",
   npc_dota_hero_snapfire = "snapfire_mortimer_kisses", 
   npc_dota_hero_tusk = "tusk_walrus_punch",
   npc_dota_hero_ursa = "ursa_enrage",
   npc_dota_hero_sniper = "sniper_assassinate",
   npc_dota_hero_mars = "mars_arena_of_blood",
   npc_dota_hero_viper = "_strike", -- Not "viper_viper_strike" because the viper strike names in SPECIAL_ABILITY_UPGRADES are wierd
   npc_dota_hero_weaver = "weaver_time_lapse",
   npc_dota_hero_witch_doctor = "witch_doctor_death_ward",
   npc_dota_hero_queenofpain = "queenofpain_sonic_wave",
   npc_dota_hero_templar_assassin = "templar_assassin_psionic_trap",
   npc_dota_hero_slark = "slark_shadow_dance",
   npc_dota_hero_lina = "lina_laguna_blade",
   npc_dota_hero_juggernaut = "juggernaut_omni_slash",
   npc_dota_hero_drow_ranger = "drow_ranger_marksmanship",
   npc_dota_hero_luna = "luna_eclipse",
   npc_dota_hero_lich = "lich_chain_frost",
   npc_dota_hero_kunkka = "kunkka_ghostship",
   npc_dota_hero_undying = "undying_flesh_golem",
   npc_dota_hero_void_spirit = "void_spirit_astral_step",
   npc_dota_hero_gyrocopter = "gyrocopter_call_down",
   npc_dota_hero_dawnbreaker = "dawnbreaker_solar_guardian",
   npc_dota_hero_bane = "bane_fiends_grip",
   npc_dota_hero_phoenix = "phoenix_supernova",
   npc_dota_hero_sand_king = "sand_king_epicenter",
   npc_dota_hero_clinkz = "clinkz_burning_army",
}

-- Lists for ability upgrades go here
_G.SPECIAL_ABILITY_UPGRADES = {}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_omniknight"] =
{
	"aghsfort_special_omniknight_purification_cast_radius",
	"aghsfort_special_omniknight_purification_charges",
	"aghsfort_special_omniknight_purification_cooldown_reduction",
	"aghsfort_special_omniknight_purification_multicast",

   "aghsfort_special_omniknight_repel_procs_purification",
   "aghsfort_special_omniknight_repel_outgoing_damage",
   --"aghsfort_special_omniknight_repel_applies_degen_aura", --needs some re-write to make it work in all cases and doesn't seem interesting anyway
   "aghsfort_special_omniknight_repel_damage_instance_refraction",
   "aghsfort_special_omniknight_repel_knockback_on_cast",

   "aghsfort_special_omniknight_degen_aura_toggle",
   "aghsfort_special_omniknight_degen_aura_damage",
   "aghsfort_special_omniknight_degen_aura_restoration",

   "aghsfort_special_omniknight_guardian_angel_purification",
   "aghsfort_special_omniknight_guardian_angel_immune_flight",
   --"aghsfort_special_omniknight_guardian_angel_single_target",
   "aghsfort_special_omniknight_guardian_angel_single_target_dummy",

}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_magnataur"] =
{
   "aghsfort_special_magnataur_shockwave_multishot",
	"aghsfort_special_magnataur_shockwave_damage_reduction",
   "aghsfort_special_magnataur_shockwave_boomerang",

--	"aghsfort_special_magnataur_empower_all_allies",
   "aghsfort_special_magnataur_empower_charges",
   "aghsfort_special_magnataur_empower_lifesteal",
   "aghsfort_special_magnataur_empower_shockwave_on_attack",

   --"aghsfort_special_magnataur_skewer_original_scepter",
   --"aghsfort_special_magnataur_friendly_skewer",
   "aghsfort_special_magnataur_skewer_bonus_strength",
   --"aghsfort_special_magnataur_skewer_heal",
   "aghsfort_magnataur_horn_toss",
   "aghsfort_special_magnataur_skewer_shockwave",

   --"aghsfort_special_magnataur_reverse_polarity_radius",
   "aghsfort_special_magnataur_reverse_polarity_polarity_dummy",
   "aghsfort_special_magnataur_reverse_polarity_allies_crit",
   "aghsfort_special_magnataur_reverse_polarity_steroid",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_phantom_assassin"] =
{
	"aghsfort_special_phantom_assassin_coup_de_grace_marks_target",
   "aghsfort_special_phantom_assassin_coup_de_grace_bloody_debuff",
   "aghsfort_special_phantom_assassin_coup_de_grace_kills_refresh",

	"aghsfort_special_phantom_assassin_stifling_dagger_no_secondary_dagger_restriction",
	"aghsfort_special_phantom_assassin_stifling_dagger_on_attack",
	"aghsfort_special_phantom_assassin_stifling_dagger_autodagger",

	"aghsfort_special_phantom_assassin_blur_regen_when_active",
	"aghsfort_special_phantom_assassin_blur_dagger_on_end",
	"aghsfort_special_phantom_assassin_blur_immediate",

	"aghsfort_special_phantom_assassin_phantom_strike_buff_allies",
	"aghsfort_special_phantom_assassin_phantom_strike_mastery",
	"aghsfort_special_phantom_assassin_phantom_strike_damage_reduction",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_winter_wyvern"] =
{
   "aghsfort_special_winter_wyvern_arctic_burn_splitshot",
   "aghsfort_special_winter_wyvern_arctic_burn_doubleattack",
   --"aghsfort_special_winter_wyvern_arctic_burn_nomana",
   "aghsfort_special_winter_wyvern_arctic_burn_splash_damage",

   "aghsfort_special_winter_wyvern_splinter_blast_main_target_hit",
   "aghsfort_special_winter_wyvern_splinter_blast_vacuum",
   "aghsfort_special_winter_wyvern_splinter_blast_heal",

   "aghsfort_special_winter_wyvern_cold_embrace_charges",
   "aghsfort_special_winter_wyvern_cold_embrace_blast_on_end",
   "aghsfort_special_winter_wyvern_cold_embrace_magic_damage_block",

   "aghsfort_special_winter_wyvern_winters_curse_transfer",
   "aghsfort_special_winter_wyvern_winters_curse_damage_amp",
   "aghsfort_special_winter_wyvern_winters_curse_heal_on_death",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_disruptor"] =
{
	"aghsfort_special_disruptor_thunder_strike_interval_upgrade",
	"aghsfort_special_disruptor_thunder_strike_mana_restore",
	"aghsfort_special_disruptor_thunder_strike_crit_chance",
	"aghsfort_special_disruptor_thunder_strike_on_attack",

--	"aghsfort_special_disruptor_glimpse_cast_aoe",
	"aghsfort_special_disruptor_glimpse_hit_on_arrival",
	"aghsfort_special_disruptor_glimpse_travel_damage",

	--"aghsfort_special_disruptor_kinetic_field_instant_setup",
	"aghsfort_special_disruptor_kinetic_field_damage",
	"aghsfort_special_disruptor_kinetic_field_allied_heal",
	"aghsfort_special_disruptor_kinetic_field_allied_attack_buff",
   "aghsfort_special_disruptor_kinetic_field_double_ring",

	"aghsfort_special_disruptor_static_storm_kinetic_field_on_cast",
	"aghsfort_special_disruptor_static_storm_crits_on_attacks",
	"aghsfort_special_disruptor_static_storm_damage_reduction",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_snapfire"] =
{
   "aghsfort_special_snapfire_scatterblast_double_barrel",
   "aghsfort_special_snapfire_scatterblast_knockback",
  -- "aghsfort_special_snapfire_scatterblast_fullrange_pointblank",
   "aghsfort_special_snapfire_scatterblast_barrage",

   "aghsfort_special_snapfire_firesnap_cookie_multicookie",
   "aghsfort_special_snapfire_firesnap_cookie_enemytarget",
   "aghsfort_special_snapfire_firesnap_cookie_allied_buff",

   "aghsfort_special_snapfire_lil_shredder_explosives",
   "aghsfort_special_snapfire_lil_shredder_ally_cast",
   "aghsfort_special_snapfire_lil_shredder_bouncing_bullets",

   "aghsfort_special_snapfire_mortimer_kisses_fragmentation",
--   "aghsfort_special_snapfire_mortimer_kisses_fire_trail",
   "aghsfort_special_snapfire_mortimer_kisses_autoattack",
   "aghsfort_special_snapfire_mortimer_kisses_incoming_damage_reduction",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tusk"] =
{
   --"aghsfort_special_tusk_ice_shards_circle",
   "aghsfort_special_tusk_ice_shards_secondary",
   "aghsfort_special_tusk_ice_shards_explode",
  -- "aghsfort_special_tusk_ice_shards_stun",
   "aghsfort_special_tusk_ice_shards_snowball",

   "aghsfort_special_tusk_snowball_heal",
   "aghsfort_special_tusk_snowball_end_damage",
   "aghsfort_special_tusk_snowball_global",

   "aghsfort_special_tusk_tag_team_lifesteal",
   "aghsfort_special_tusk_tag_team_toggle",
   "aghsfort_special_tusk_tag_team_death_cooldown",
   --"aghsfort_special_tusk_tag_team_global",

   "aghsfort_special_tusk_walrus_punch_reset",
   "aghsfort_special_tusk_walrus_punch_land_damage",
   "aghsfort_special_tusk_walrus_punch_wallop",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_ursa"] =
{
   "aghsfort_special_ursa_earthshock_knockback",
   "aghsfort_special_ursa_earthshock_apply_fury_swipes", 
   "aghsfort_special_ursa_earthshock_overpower_stack",
   
   "aghsfort_special_ursa_overpower_crit",
   "aghsfort_special_ursa_overpower_evasion",
   "aghsfort_special_ursa_overpower_cleave",

   "aghsfort_special_ursa_fury_swipes_armor_reduction",
   "aghsfort_special_ursa_fury_swipes_lifesteal",
   "aghsfort_special_ursa_fury_swipes_ursa_minor",

   "aghsfort_special_ursa_enrage_earthshock",
   "aghsfort_special_ursa_enrage_attack_speed",
   "aghsfort_special_ursa_enrage_allies",

    -- "aghsfort_special_ursa_earthshock_invis",
   --"aghsfort_special_ursa_earthshock_miss_chance",
   -- "aghsfort_special_ursa_overpower_taunt",
   --"aghsfort_special_ursa_enrage_magic_immunity",
   --"aghsfort_special_ursa_enrage_fear",
   --"aghsfort_special_ursa_enrage_armor",
 
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_sniper"] =
{
   "aghsfort_special_sniper_shrapnel_bombs",
   "aghsfort_special_sniper_shrapnel_attack_speed",
   "aghsfort_special_sniper_shrapnel_move_speed",
 
   "aghsfort_special_sniper_headshot_armor_reduction",
   "aghsfort_special_sniper_headshot_shotgun",
   "aghsfort_special_sniper_headshot_assassinate",

   "aghsfort_special_sniper_take_aim_self_purge",
   "aghsfort_special_sniper_take_aim_rapid_fire",
   "aghsfort_special_sniper_take_aim_shrapnel",
  
   "aghsfort_special_sniper_assassinate_buckshot",
   "aghsfort_special_sniper_assassinate_original_scepter",
   "aghsfort_special_sniper_assassinate_concussive_dummy",

    -- "aghsfort_special_sniper_headshot_stuns",
   --"aghsfort_special_sniper_headshot_crits",
   --"aghsfort_special_sniper_shrapnel_miss_chance",
   --"aghsfort_special_sniper_take_aim_hop_backwards",
   --"aghsfort_special_sniper_take_aim_armor_reduction",
   --"aghsfort_special_sniper_take_aim_rapid_fire",
   --"aghsfort_special_sniper_assassinate_killshot",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_mars"] = 
{
   "aghsfort_special_mars_spear_multiskewer",
   "aghsfort_special_mars_spear_impale_explosion",
   "aghsfort_special_mars_spear_burning_trail",

   "aghsfort_special_mars_gods_rebuke_full_circle",
   "aghsfort_special_mars_gods_rebuke_stun",
   "aghsfort_special_mars_gods_rebuke_strength_buff",

   "aghsfort_special_mars_bulwark_counter_rebuke",
   --"aghsfort_special_mars_bulwark_healing",
   --"aghsfort_special_mars_bulwark_return",
   "aghsfort_special_mars_bulwark_spears",
   "aghsfort_special_mars_bulwark_soldiers",

   "aghsfort_special_mars_arena_of_blood_outside_perimeter",
   --"aghsfort_special_mars_arena_of_blood_fear",
   "aghsfort_special_mars_arena_of_blood_global",
   "aghsfort_special_mars_arena_of_blood_attack_buff",
}
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_viper"] = 
{
   "aghsfort_special_viper_poison_attack_spread",
   "aghsfort_special_viper_poison_attack_explode",
   "aghsfort_special_viper_poison_snap",

   "aghsfort_special_viper_nethertoxin_lifesteal",
   "aghsfort_special_viper_nethertoxin_charges",
   "aghsfort_special_viper_nethertoxin_persist",

   "aghsfort_special_viper_corrosive_skin_speed_steal",
   "aghsfort_special_viper_corrosive_skin_flying",
   "aghsfort_special_viper_corrosive_skin_aura",

   "aghsfort_special_viper_viper_strike_allies",
   --"aghsfort_special_viper_channeled_viper_strike",
   "aghsfort_special_viper_periodic_strike",
   "aghsfort_special_viper_chain_viper_strike",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_weaver"] = 
{
   "aghsfort_special_weaver_swarm_allies",
   "aghsfort_special_weaver_swarm_explosion",
   "aghsfort_special_weaver_swarm_damage_transfer",

   "aghsfort_special_weaver_geminate_attack_splitshot",
   "aghsfort_special_weaver_geminate_attack_applies_swarm",  
   "aghsfort_special_weaver_geminate_attack_lifesteal",
  -- "aghsfort_special_weaver_geminate_attack_knockback",



  -- "aghsfort_special_weaver_shukuchi_pull",
  "aghsfort_special_weaver_shukuchi_trail",
  --"aghsfort_special_weaver_shukuchi_heal",
  "aghsfort_special_weaver_shukuchi_attack_on_completion",
  "aghsfort_special_weaver_shukuchi_swarm",
  --"aghsfort_special_weaver_shukuchi_greater_invisibility",

  "aghsfort_special_weaver_time_lapse_allies",
  "aghsfort_special_weaver_time_lapse_restoration",
  "aghsfort_special_weaver_time_lapse_explosion",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_witch_doctor"] = 
{

   "aghsfort_special_witch_doctor_paralyzing_cask_multicask",
   "aghsfort_special_witch_doctor_paralyzing_cask_applies_maledict",
   "aghsfort_special_witch_doctor_paralyzing_cask_aoe_damage",
   "aghsfort_special_witch_doctor_paralyzing_cask_attack_procs",
   
   --"aghsfort_special_witch_doctor_maledict_ground_curse",
   "aghsfort_special_witch_doctor_maledict_aoe_procs",
   "aghsfort_special_witch_doctor_maledict_death_restoration",
  -- "aghsfort_special_witch_doctor_maledict_affects_allies",
   "aghsfort_special_witch_doctor_maledict_infectious",
   
   "aghsfort_special_witch_doctor_voodoo_restoration_enemy_damage",
   "aghsfort_special_witch_doctor_voodoo_restoration_lifesteal",
   "aghsfort_special_witch_doctor_voodoo_restoration_damage_amp",
   --"aghsfort_special_witch_doctor_voodoo_restoration_mana_restore",
   
   "aghsfort_special_witch_doctor_death_ward_no_channel",
   "aghsfort_special_witch_doctor_death_ward_splitshot",
   "aghsfort_special_witch_doctor_death_ward_damage_resist",
   --"aghsfort_special_witch_doctor_death_ward_bounce",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_queenofpain"] =
{
   "aghsfort_special_queenofpain_shadow_strike_on_attack",
   "aghsfort_special_queenofpain_shadow_strike_chain",
   "aghsfort_special_queenofpain_shadow_strike_scream",

   "aghsfort_special_queenofpain_blink_generates_scream",
   "aghsfort_special_queenofpain_blink_attack_speed",
   "aghsfort_special_queenofpain_blink_shadow_strike",

   "aghsfort_special_queenofpain_scream_of_pain_resets_blink",
   "aghsfort_special_queenofpain_scream_of_pain_restores_caster",
   "aghsfort_special_queenofpain_scream_of_pain_knockback",

   "aghsfort_special_queenofpain_sonic_wave_trail",
   "aghsfort_special_queenofpain_sonic_wave_circle",
   "aghsfort_special_queenofpain_sonic_wave_attack_buff",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_templar_assassin"] = 
{

   --"aghsfort_special_templar_assassin_refraction_allies",
   "aghsfort_special_templar_assassin_refraction_kill_refresh",
  -- "aghsfort_special_templar_assassin_refraction_counter_attack",
   "aghsfort_special_templar_assassin_refraction_detonate_trap",


   "aghsfort_special_templar_assassin_meld_attack_on_activation",
   "aghsfort_special_templar_assassin_meld_teleport",
   "aghsfort_special_templar_assassin_meld_refraction_on_kill", 
   

   --"aghsfort_special_templar_assassin_psi_blades_autoattack",
   "aghsfort_special_templar_assassin_psi_blades_trap",
   "aghsfort_special_templar_assassin_psi_blades_splash", 

   "aghsfort_special_templar_assassin_psionic_trap_area_attack",
   "aghsfort_special_templar_assassin_psionic_trap_damage_heals",
   "aghsfort_special_templar_assassin_psionic_trap_multipulse",
   
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_slark"] =
{
   "aghsfort_special_slark_dark_pact_essence_shift",
   "aghsfort_special_slark_dark_pact_push_stun",
   --"aghsfort_special_slark_dark_pact_dispells_allies",
   "aghsfort_special_slark_dark_pact_unit_target",

   "aghsfort_special_slark_pounce_attack_all",
   "aghsfort_special_slark_pounce_projectiles",
   "aghsfort_special_slark_pounce_leashed_bonus",

   "aghsfort_special_slark_essence_shift_aoe_attack",
   "aghsfort_special_slark_essence_shift_leash_chance",
   "aghsfort_special_slark_essence_shift_allied_buff",

   "aghsfort_special_slark_shadow_dance_essence_shift_bonus",
   "aghsfort_special_slark_shadow_dance_dark_pact_pulses",
   "aghsfort_special_slark_shadow_dance_leash",

}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lina"] =
{
   "aghsfort_special_lina_dragon_slave_lsa_trail",
   "aghsfort_special_lina_dragon_slave_triwave",
   "aghsfort_special_lina_dragon_slave_ignite",
   "aghsfort_special_lina_dragon_slave_booster",

   "aghsfort_special_lina_light_strike_array_pulsate",
   "aghsfort_special_lina_light_strike_array_attacks",
   "aghsfort_special_lina_light_strike_array_vacuum",

   "aghsfort_special_lina_fiery_soul_multishot",
--   "aghsfort_special_lina_fiery_soul_dragon_slave_on_cast",
--   "aghsfort_special_lina_fiery_soul_dragon_slave_mini_lagunas",
--   "aghsfort_special_lina_fiery_soul_lsa_attacks",
   "aghsfort_special_lina_fiery_soul_ally_cast",

   "aghsfort_special_lina_laguna_blade_bounce",
--   "aghsfort_special_lina_laguna_blade_lsa",
   "aghsfort_special_lina_laguna_blade_channel",
   "aghsfort_special_lina_laguna_blade_line",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_undying"] =
{
   "aghsfort_special_undying_decay_spawn_zombies",
   "aghsfort_special_undying_decay_on_attack",
   "aghsfort_special_undying_decay_reverberation",

   "aghsfort_special_undying_soul_rip_ward",
   --"aghsfort_special_undying_soul_rip_charges",  -- moving to talent
   "aghsfort_special_undying_soul_rip_spawn_zombies",
   "aghsfort_special_undying_soul_rip_share_strength",

   "aghsfort_special_undying_consume_zombies_dummy",
   "aghsfort_special_undying_tombstone_exploding_zombies",
   "aghsfort_special_undying_tombstone_bunker",

   "aghsfort_special_undying_flesh_golem_spawn_zombies",
   "aghsfort_special_undying_flesh_golem_heal_on_enemy_death",
   "aghsfort_special_undying_flesh_golem_smash",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_juggernaut"] =
{
   "aghsfort_special_juggernaut_blade_fury_sparks",
   "aghsfort_special_juggernaut_blade_fury_force",
   "aghsfort_special_juggernaut_blade_dance_launches_blade_fury",   

   "aghsfort_special_juggernaut_healing_ward_blade_fury",
   "aghsfort_special_juggernaut_healing_ward_detonate",
   "aghsfort_special_juggernaut_zen_ward",

   "aghsfort_special_juggernaut_blade_dance_cooldown",
   "aghsfort_special_juggernaut_blade_dance_teleport",
   "aghsfort_special_juggernaut_blade_dance_buff",

   "aghsfort_special_juggernaut_omni_slash_shared",
   "aghsfort_special_juggernaut_omni_slash_spin",
   "aghsfort_special_juggernaut_omni_slash_ignite",
   
   --"aghsfort_special_juggernaut_blade_fury_lifesteal_hit",
   -- "aghsfort_special_juggernaut_blade_fury_shared",
   -- "aghsfort_special_juggernaut_healing_ward_crit",
   -- "aghsfort_special_juggernaut_blade_dance_shared",
   -- "aghsfort_special_juggernaut_omni_slash_range",
   -- "aghsfort_special_juggernaut_omni_slash_illusion",
   -- "aghsfort_special_juggernaut_omni_slash_crit_extend",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_drow_ranger"] =
{
   "aghsfort2_special_drow_ranger_frost_arrows_split",
   "aghsfort2_special_drow_ranger_frost_arrows_move_damage",
   "aghsfort2_special_drow_ranger_frost_arrows_wave",

   "aghsfort2_special_drow_ranger_wave_of_silence_echo",
   "aghsfort2_special_drow_ranger_wave_of_silence_movement",
   "aghsfort2_special_drow_ranger_wave_of_silence_cooldown",
   "aghsfort2_special_drow_ranger_wave_of_silence_frost",

   "aghsfort2_special_drow_ranger_multi_shot_move",
   "aghsfort2_special_drow_ranger_multi_shot_side_line",
   "aghsfort2_special_drow_ranger_multi_shot_buff",

   "aghsfort2_special_drow_ranger_marksmanship_waveofsilence",
   "aghsfort2_special_drow_ranger_marksmanship_aoe",
   
   --"aghsfort2_special_drow_ranger_multi_shot_refire",
}



SPECIAL_ABILITY_UPGRADES["npc_dota_hero_luna"] =
{
	-- Lucent Beam
   "aghsfort_special_luna_lucent_beam_diffusion",
   "aghsfort_special_luna_lucent_beam_moonglow",
   "aghsfort_special_luna_lucent_beam_glaives",
	
	-- Glaives
   "aghsfort_special_luna_moon_glaive_knockback",
   "aghsfort_special_luna_moon_glaive_glaive_shield",
   "aghsfort_special_luna_glaives_moon_well",
	
	-- Lunar Blessing
   "aghsfort_special_luna_lunar_blessing_lunar_remnant",
   "aghsfort_special_luna_lunar_blessing_leap",
   "aghsfort_special_luna_lunar_blessing_moon_mark",
  
	-- Eclipse
   "aghsfort_special_luna_eclipse_lunar_cycle",
   "aghsfort_special_luna_eclipse_lunar_focus",
   "aghsfort_special_luna_eclipse_hide",


   --"aghsfort_special_luna_lucent_beam_bloodmoon",
   --"aghsfort_special_luna_moon_glaive_ally_bounce",
   --"aghsfort_special_luna_moon_glaive_double_moon",
    --"aghsfort_special_luna_lunar_blessing_lunar_power",

   --"aghsfort_special_luna_lunar_blessing_moon_shield",
   --"aghsfort_special_luna_lunar_blessing_moonfright",

	--"aghsfort_special_luna_eclipse_moonstruck",
	--"aghsfort_special_luna_eclipse_lunar_favor",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lich"] =
{
   "aghsfort_special_lich_frost_nova_root_disarm",
   -- "aghsfort_special_lich_frost_nova_applies_frost_shield",
   "aghsfort_special_lich_frost_nova_execute_refund",
   "aghsfort_special_lich_frost_nova_aoe_attacks",

   "aghsfort_special_lich_frost_shield_magic_resist_debuff_and_stun",
   -- "aghsfort_special_lich_frost_shield_heal",
   "aghsfort_special_lich_frost_shield_frost_giant",
   "aghsfort_special_lich_frost_shield_dispels",

   "aghsfort_special_lich_sinister_gaze_spawns_ice_spire",
   "aghsfort_special_lich_sinister_gaze_drains_life",
   "aghsfort_special_lich_sinister_gaze_raises_skeletons",

   "aghsfort_special_lich_chain_frost_split",
   "aghsfort_special_lich_chain_frost_applies_frost_shield",
   "aghsfort_special_lich_chain_frost_applies_frost_nova",

}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_kunkka"] =
{
	-- Ghost ship upgrades
   "aghsfort_special_kunkka_ghost_ship_fire_cannons", -- "Man o' War"
   "aghsfort_special_kunkka_rumboldened",
   "aghsfort_special_kunkka_skull_and_bones",
   "aghsfort_special_kunkka_davy_jones_locker",
	-- X-marks upgrades
   "aghsfort_special_kunkka_grog_blossom",
   -- "aghsfort_special_kunkka_angry_recall",				-- "Shore Leave's Over" -- Turning off for now.  Sergei had a good point that sealegs is a superset of this; so it could use redesign.
   "aghsfort_special_kunkka_sealegs",
   "aghsfort_special_kunkka_dread_pirate",
	-- Tidebringer upgrades
   "aghsfort_special_kunkka_tsunami",
   "aghsfort_special_kunkka_no_quarter",
	-- Torrent upgrades
   "aghsfort_special_kunkka_squall",
   "aghsfort_special_kunkka_marked",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_void_spirit" ] =
{
   "aghsfort_special_void_spirit_aether_remnant_phantom_attack",
   "aghsfort_special_void_spirit_aether_remnant_bowling",

   "aghsfort_special_void_spirit_dissimilate_translocate",
   "aghsfort_special_void_spirit_dissimilate_expanse",
   "aghsfort_special_void_spirit_dissimilate_remnants",
   "aghsfort_special_void_spirit_dissimilate_lure",

   "aghsfort_special_void_spirit_resonant_pulse_knockback",
   "aghsfort_special_void_spirit_resonant_pulse_cadence",
   "aghsfort_special_void_spirit_resonant_pulse_suppression",

   "aghsfort_special_void_spirit_astral_step_attacks",
   "aghsfort_special_void_spirit_astral_step_trail",
   "aghsfort_special_void_spirit_astral_step_breach",
   --"aghsfort_special_void_spirit_astral_step_vacuum", -- REMOVED
}


SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_gyrocopter" ] =
{
   "aghsfort_special_gyrocopter_rocket_barrage_on_attack",
   --"aghsfort_special_gyrocopter_rocket_barrage_double_target",
  -- "aghsfort_special_gyrocopter_rocket_barrage_flare",
   "aghsfort_special_gyrocopter_rocket_barrage_ground",

   "aghsfort_special_gyrocopter_homing_missile_barrage",
   "aghsfort_special_gyrocopter_homing_missile_ride",
   "aghsfort_special_gyrocopter_homing_missile_minimissile",
   "aghsfort_special_gyrocopter_homing_missile_call_down",

   "aghsfort_special_gyrocopter_flak_cannon_first_strike",
   --"aghsfort_special_gyrocopter_flak_cannon_side_gunner",
   "aghsfort_special_gyrocopter_flak_cannon_missiles",
   "aghsfort_special_gyrocopter_flak_cannon_fire_trail",


   --"aghsfort_special_gyrocopter_call_down_attack_buff",
   "aghsfort_special_gyrocopter_call_down_minefield",
   "aghsfort_special_gyrocopter_call_down_strafe",
   "aghsfort_special_gyrocopter_call_down_precision_strike",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_dawnbreaker" ] =
{
   "aghsfort_special_dawnbreaker_starbreaker_celestial_fire",
   "aghsfort_special_dawnbreaker_starbreaker_counter_orbital",
   "aghsfort_special_dawnbreaker_starbreaker_suncrusher",

   "aghsfort_special_dawnbreaker_celestial_hammer_hammer_time",
   "aghsfort_special_dawnbreaker_celestial_hammer_sunforge",
   "aghsfort_special_dawnbreaker_celestial_hammer_haven",

   "aghsfort_special_dawnbreaker_luminosity_solar_battery",
   "aghsfort_special_dawnbreaker_luminosity_bright_foundry",
   "aghsfort_special_dawnbreaker_luminosity_light_bringer",

   "aghsfort_special_dawnbreaker_solar_guardian_sun_sentinel",
   "aghsfort_special_dawnbreaker_solar_guardian_death_of_a_star",
   "aghsfort_special_dawnbreaker_solar_guardian_solar_flare",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_bane" ] =
{
   "aghsfort_special_bane_enfeeble_spill",
   "aghsfort_special_bane_enfeeble_end_fiends_grip",
   "aghsfort_special_bane_enfeeble_allies",

   "aghsfort_special_bane_brain_sap_knockback_slow",
   "aghsfort_special_bane_brain_sap_nightmare_mirror",
   "aghsfort_special_bane_brain_sap_invis",

   "aghsfort_special_bane_nightmare_nightmare_burst",
   "aghsfort_special_bane_nightmare_sweet_dreams",
   "aghsfort_special_bane_nightmare_confusion",

   "aghsfort_special_bane_fiends_grip_spread",
   "aghsfort_special_bane_fiends_grip_boost_ally",
   "aghsfort_special_bane_fiends_grip_auto_nightmare",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_phoenix" ] =
{
   "aghsfort_special_phoenix_icarus_dive_savior",
   "aghsfort_special_phoenix_icarus_dive_blast_wave",
   "aghsfort_special_phoenix_icarus_dive_second_sun",

   "aghsfort_special_phoenix_fire_spirits_vitality",
   "aghsfort_special_phoenix_fire_spirits_artillery",
   "aghsfort_special_phoenix_fire_spirits_flame_revenant",

   "aghsfort_special_phoenix_sun_ray_luminance",
   "aghsfort_special_phoenix_sun_ray_focus_point",
   "aghsfort_special_phoenix_sun_ray_gamma_ray",

   "aghsfort_special_phoenix_supernova_capture",
   "aghsfort_special_phoenix_supernova_horizon",
   "aghsfort_special_phoenix_supernova_expel_core",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_sand_king" ] =
{
   "aghsfort_special_sand_king_burrowstrike_channel",
   "aghsfort_special_sand_king_burrowstrike_transport",
   "aghsfort_special_sand_king_burrowstrike_reverse",

   "aghsfort_special_sand_king_sandstorm_independant",
   "aghsfort_special_sand_king_sandstorm_burrowstrike_field",
   "aghsfort_special_sand_king_sandstorm_vacuum",

   "aghsfort_special_sand_king_caustic_finale_sandstorm",
   "aghsfort_special_sand_king_caustic_finale_active",
   "aghsfort_special_sand_king_caustic_finale_strength_buff",

   "aghsfort_special_sand_king_epicenter_movement",
   "aghsfort_special_sand_king_epicenter_allies",
   "aghsfort_special_sand_king_epicenter_damage_resist",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_clinkz" ] =
{
   "aghsfort_special_clinkz_burning_barrage_tri_split",
   "aghsfort_special_clinkz_burning_barrage_skeleton_shot",
   "aghsfort_special_clinkz_burning_barrage_singe",

   "aghsfort_special_clinkz_searing_arrows_ignite",
   "aghsfort_special_clinkz_searing_arrows_skeletal_colossus",
   "aghsfort_special_clinkz_searing_arrows_melter",

   "aghsfort_special_clinkz_skeleton_walk_beckon_undead",
   "aghsfort_special_clinkz_skeleton_walk_wraith_touch",
   "aghsfort_special_clinkz_skeleton_walk_strafe",

   "aghsfort_special_clinkz_burning_army_entrenchment",
   "aghsfort_special_clinkz_burning_army_big_skeletons",
   "aghsfort_special_clinkz_burning_army_stunning_skeletons",
}

require( "items/item_small_scepter_fragment" )

_G.PURCHASABLE_SHARDS = {}

--Disruptor
item_aghsfort_disruptor_thunder_strike_flat_strikes = item_small_scepter_fragment
item_aghsfort_disruptor_thunder_strike_flat_strike_damage = item_small_scepter_fragment
item_aghsfort_disruptor_glimpse_flat_bonus_damage = item_small_scepter_fragment
item_aghsfort_disruptor_glimpse_flat_cast_radius = item_small_scepter_fragment
item_aghsfort_disruptor_kinetic_field_flat_duration = item_small_scepter_fragment
item_aghsfort_disruptor_kinetic_field_formation_time = item_small_scepter_fragment
item_aghsfort_disruptor_static_storm_flat_duration = item_small_scepter_fragment
item_aghsfort_disruptor_static_storm_flat_damage_max = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_disruptor" ] =
{
   "item_aghsfort_disruptor_thunder_strike_flat_strikes",
   "item_aghsfort_disruptor_thunder_strike_flat_strike_damage",
   "item_aghsfort_disruptor_glimpse_flat_bonus_damage",
   "item_aghsfort_disruptor_glimpse_flat_cast_radius",
   "item_aghsfort_disruptor_kinetic_field_flat_duration",
   "item_aghsfort_disruptor_kinetic_field_formation_time",
   "item_aghsfort_disruptor_static_storm_flat_duration",
   "item_aghsfort_disruptor_static_storm_flat_damage_max",
}

--Magnus
item_aghsfort_magnataur_shockwave_flat_damage = item_small_scepter_fragment
item_aghsfort_magnataur_shockwave_pct_mana_cost = item_small_scepter_fragment
item_aghsfort_magnataur_empower_flat_damage = item_small_scepter_fragment
item_aghsfort_magnataur_empower_flat_cleave = item_small_scepter_fragment
item_aghsfort_magnataur_skewer_flat_damage = item_small_scepter_fragment
item_aghsfort_magnataur_skewer_pct_cooldown = item_small_scepter_fragment
item_aghsfort_magnataur_reverse_polarity_flat_damage = item_small_scepter_fragment
item_aghsfort_magnataur_reverse_polarity_flat_radius = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_magnataur" ] =
{
   "item_aghsfort_magnataur_shockwave_flat_damage",
   "item_aghsfort_magnataur_shockwave_pct_mana_cost",
   "item_aghsfort_magnataur_empower_flat_damage",
   "item_aghsfort_magnataur_empower_flat_cleave",
   "item_aghsfort_magnataur_skewer_flat_damage",
   "item_aghsfort_magnataur_skewer_pct_cooldown",
   "item_aghsfort_magnataur_reverse_polarity_flat_damage",
   "item_aghsfort_magnataur_reverse_polarity_flat_radius",
}

--Mars
item_aghsfort_mars_spear_flat_damage = item_small_scepter_fragment
item_aghsfort_mars_spear_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_mars_gods_rebuke_percent_cooldown = item_small_scepter_fragment
item_aghsfort_mars_gods_rebuke_flat_crit_mult = item_small_scepter_fragment
item_aghsfort_mars_bulwark_damage_reduction_front = item_small_scepter_fragment
item_aghsfort_mars_bulwark_active_duration = item_small_scepter_fragment
item_aghsfort_mars_arena_of_blood_duration = item_small_scepter_fragment
item_aghsfort_mars_arena_of_blood_spear_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_mars" ] =
{
   "item_aghsfort_mars_spear_flat_damage",
   "item_aghsfort_mars_spear_flat_stun_duration",
   "item_aghsfort_mars_gods_rebuke_percent_cooldown",
   "item_aghsfort_mars_gods_rebuke_flat_crit_mult",
   "item_aghsfort_mars_bulwark_damage_reduction_front",
   "item_aghsfort_mars_bulwark_active_duration",
   "item_aghsfort_mars_arena_of_blood_duration",
   "item_aghsfort_mars_arena_of_blood_spear_damage",
}

--Omni
item_aghsfort_omniknight_purification_manacost = item_small_scepter_fragment
item_aghsfort_omniknight_purification_flat_heal = item_small_scepter_fragment
item_aghsfort_omniknight_repel_flat_duration = item_small_scepter_fragment
item_aghsfort_omniknight_repel_flat_damage_reduction = item_small_scepter_fragment
item_aghsfort_omniknight_degen_aura_flat_radius = item_small_scepter_fragment
item_aghsfort_omniknight_degen_aura_flat_move_speed_bonus = item_small_scepter_fragment
item_aghsfort_omniknight_guardian_angel_flat_duration = item_small_scepter_fragment
item_aghsfort_omniknight_guardian_angel_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_omniknight" ] =
{
   "item_aghsfort_omniknight_purification_manacost",
   "item_aghsfort_omniknight_purification_flat_heal",
   "item_aghsfort_omniknight_repel_flat_duration",
   "item_aghsfort_omniknight_repel_flat_damage_reduction",
   "item_aghsfort_omniknight_degen_aura_flat_radius",
   "item_aghsfort_omniknight_degen_aura_flat_move_speed_bonus",
   "item_aghsfort_omniknight_guardian_angel_flat_duration",
   "item_aghsfort_omniknight_guardian_angel_cooldown",
}

-- Queen Of Pain
item_aghsfort_queenofpain_shadow_strike_strike_damage = item_small_scepter_fragment
item_aghsfort_queenofpain_shadow_strike_dot_damage = item_small_scepter_fragment
item_aghsfort_queenofpain_blink_percent_cooldown = item_small_scepter_fragment
item_aghsfort_queenofpain_blink_range = item_small_scepter_fragment
item_aghsfort_queenofpain_scream_of_pain_damage = item_small_scepter_fragment
item_aghsfort_queenofpain_scream_of_pain_radius = item_small_scepter_fragment
item_aghsfort_queenofpain_sonic_wave_percent_cooldown = item_small_scepter_fragment
item_aghsfort_queenofpain_sonic_wave_damage = item_small_scepter_fragment


PURCHASABLE_SHARDS[ "npc_dota_hero_queenofpain" ] =
{
   "item_aghsfort_queenofpain_shadow_strike_strike_damage",
   "item_aghsfort_queenofpain_shadow_strike_dot_damage",
   "item_aghsfort_queenofpain_blink_percent_cooldown",
   "item_aghsfort_queenofpain_blink_range",
   "item_aghsfort_queenofpain_scream_of_pain_damage",
   "item_aghsfort_queenofpain_scream_of_pain_radius",
   "item_aghsfort_queenofpain_sonic_wave_percent_cooldown",
   "item_aghsfort_queenofpain_sonic_wave_damage",
}

--Slark
item_aghsfort_slark_dark_pact_cooldown = item_small_scepter_fragment
item_aghsfort_slark_dark_pact_total_damage = item_small_scepter_fragment
item_aghsfort_slark_pounce_distance = item_small_scepter_fragment
item_aghsfort_slark_pounce_damage = item_small_scepter_fragment
item_aghsfort_slark_essence_shift_agi_gain = item_small_scepter_fragment
item_aghsfort_slark_essence_shift_max_stacks = item_small_scepter_fragment
item_aghsfort_slark_shadow_dance_duration = item_small_scepter_fragment
item_aghsfort_slark_shadow_dance_bonus_bonus_regen_pct = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_slark" ] =
{
   "item_aghsfort_slark_dark_pact_cooldown",
   "item_aghsfort_slark_dark_pact_total_damage",
   "item_aghsfort_slark_pounce_distance",
   "item_aghsfort_slark_pounce_damage",
   "item_aghsfort_slark_essence_shift_agi_gain",
   "item_aghsfort_slark_essence_shift_max_stacks",
   "item_aghsfort_slark_shadow_dance_duration",
   "item_aghsfort_slark_shadow_dance_bonus_bonus_regen_pct",
}

--Snapfire
item_aghsfort_snapfire_scatterblast_flat_damage = item_small_scepter_fragment
item_aghsfort_snapfire_scatterblast_pct_cooldown = item_small_scepter_fragment
item_aghsfort_snapfire_firesnap_cookie_flat_impact_damage = item_small_scepter_fragment
item_aghsfort_snapfire_firesnap_cookie_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_snapfire_lil_shredder_flat_damage = item_small_scepter_fragment
item_aghsfort_snapfire_lil_shredder_flat_attacks = item_small_scepter_fragment
item_aghsfort_snapfire_mortimer_kisses_flat_projectile_count = item_small_scepter_fragment
item_aghsfort_snapfire_mortimer_kisses_flat_burn_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_snapfire" ] =
{
   "item_aghsfort_snapfire_scatterblast_flat_damage",
   "item_aghsfort_snapfire_scatterblast_pct_cooldown",
   "item_aghsfort_snapfire_firesnap_cookie_flat_impact_damage",
   "item_aghsfort_snapfire_firesnap_cookie_flat_stun_duration",
   "item_aghsfort_snapfire_lil_shredder_flat_damage",
   "item_aghsfort_snapfire_lil_shredder_flat_attacks",
   "item_aghsfort_snapfire_mortimer_kisses_flat_projectile_count",
   "item_aghsfort_snapfire_mortimer_kisses_flat_burn_damage",
}

--Sniper
item_aghsfort_sniper_shrapnel_flat_damage = item_small_scepter_fragment
item_aghsfort_sniper_shrapnel_flat_radius = item_small_scepter_fragment
item_aghsfort_sniper_shrapnel_duration = item_small_scepter_fragment
item_aghsfort_sniper_headshot_flat_damage = item_small_scepter_fragment
item_aghsfort_sniper_headshot_proc_chance = item_small_scepter_fragment
item_aghsfort_sniper_take_aim_flat_bonus_attack_range = item_small_scepter_fragment
item_aghsfort_sniper_assassinate_flat_damage = item_small_scepter_fragment
item_aghsfort_sniper_assassinate_percent_cast_point = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_sniper" ] =
{
   "item_aghsfort_sniper_shrapnel_flat_damage",
   "item_aghsfort_sniper_shrapnel_flat_radius",
   "item_aghsfort_sniper_shrapnel_duration",
   "item_aghsfort_sniper_headshot_flat_damage",
   "item_aghsfort_sniper_headshot_proc_chance",
   "item_aghsfort_sniper_take_aim_flat_bonus_attack_range",
   "item_aghsfort_sniper_assassinate_flat_damage",
   "item_aghsfort_sniper_assassinate_percent_cast_point",
}

--Templar Assassin
item_aghsfort_templar_assassin_refraction_instances = item_small_scepter_fragment
item_aghsfort_templar_assassin_refraction_bonus_damage = item_small_scepter_fragment
item_aghsfort_templar_assassin_meld_bonus_damage = item_small_scepter_fragment
item_aghsfort_templar_assassin_meld_bonus_armor = item_small_scepter_fragment
item_aghsfort_templar_assassin_psi_blades_bonus_attack_range = item_small_scepter_fragment
item_aghsfort_templar_assassin_psi_blades_attack_spill_width = item_small_scepter_fragment
item_aghsfort_templar_assassin_psionic_trap_max_traps = item_small_scepter_fragment
item_aghsfort_templar_assassin_psionic_trap_trap_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_templar_assassin" ] =
{
   "item_aghsfort_templar_assassin_refraction_instances",
   "item_aghsfort_templar_assassin_refraction_bonus_damage",
   "item_aghsfort_templar_assassin_meld_bonus_damage",
   "item_aghsfort_templar_assassin_meld_bonus_armor",
   "item_aghsfort_templar_assassin_psi_blades_bonus_attack_range",
   "item_aghsfort_templar_assassin_psi_blades_attack_spill_width",
   "item_aghsfort_templar_assassin_psionic_trap_max_traps",
   "item_aghsfort_templar_assassin_psionic_trap_trap_damage",
}

--Tusk
item_aghsfort_tusk_ice_shards_flat_damage = item_small_scepter_fragment
item_aghsfort_tusk_ice_shards_flat_shard_duration = item_small_scepter_fragment
item_aghsfort_tusk_snowball_flat_snowball_damage = item_small_scepter_fragment
item_aghsfort_tusk_snowball_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_tusk_tag_team_flat_damage = item_small_scepter_fragment
item_aghsfort_tusk_tag_team_pct_cooldown = item_small_scepter_fragment
item_aghsfort_tusk_walrus_punch_pct_cooldown = item_small_scepter_fragment
item_aghsfort_tusk_walrus_punch_flat_crit_multiplier = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_tusk" ] =
{
   "item_aghsfort_tusk_ice_shards_flat_damage",
   "item_aghsfort_tusk_ice_shards_flat_shard_duration",
   "item_aghsfort_tusk_snowball_flat_snowball_damage",
   "item_aghsfort_tusk_snowball_flat_stun_duration",
   "item_aghsfort_tusk_tag_team_flat_damage",
   "item_aghsfort_tusk_tag_team_pct_cooldown",
   "item_aghsfort_tusk_walrus_punch_pct_cooldown",
   "item_aghsfort_tusk_walrus_punch_flat_crit_multiplier",
}

--Ursa
item_aghsfort_ursa_earthshock_flat_damage = item_small_scepter_fragment
item_aghsfort_ursa_earthshock_flat_radius = item_small_scepter_fragment
item_aghsfort_ursa_overpower_flat_max_attacks = item_small_scepter_fragment
item_aghsfort_ursa_overpower_percent_cooldown = item_small_scepter_fragment
item_aghsfort_ursa_fury_swipes_flat_damage_per_stack = item_small_scepter_fragment
item_aghsfort_ursa_fury_swipes_flat_max_swipe_stack = item_small_scepter_fragment
item_aghsfort_ursa_enrage_flat_duration = item_small_scepter_fragment
item_aghsfort_ursa_enrage_percent_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_ursa" ] =
{
   "item_aghsfort_ursa_earthshock_flat_damage",
   "item_aghsfort_ursa_earthshock_flat_radius",
   "item_aghsfort_ursa_overpower_flat_max_attacks",
   "item_aghsfort_ursa_overpower_percent_cooldown",
   "item_aghsfort_ursa_fury_swipes_flat_damage_per_stack",
   "item_aghsfort_ursa_fury_swipes_flat_max_swipe_stack",
   "item_aghsfort_ursa_enrage_flat_duration",
   "item_aghsfort_ursa_enrage_percent_cooldown",
}

--Viper
item_aghsfort_viper_poison_attack_damage = item_small_scepter_fragment
item_aghsfort_viper_poison_attack_magic_resistance = item_small_scepter_fragment
item_aghsfort_viper_nethertoxin_max_damage = item_small_scepter_fragment
item_aghsfort_viper_nethertoxin_radius = item_small_scepter_fragment
item_aghsfort_viper_corrosive_skin_bonus_magic_resistance = item_small_scepter_fragment
item_aghsfort_viper_corrosive_skin_damage = item_small_scepter_fragment
item_aghsfort_viper_viper_strike_duration = item_small_scepter_fragment
item_aghsfort_viper_viper_strike_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_viper" ] =
{
   "item_aghsfort_viper_poison_attack_damage",
   "item_aghsfort_viper_poison_attack_magic_resistance",
   "item_aghsfort_viper_nethertoxin_max_damage",
   "item_aghsfort_viper_nethertoxin_radius",
   "item_aghsfort_viper_corrosive_skin_bonus_magic_resistance",
   "item_aghsfort_viper_corrosive_skin_damage",
   "item_aghsfort_viper_viper_strike_duration",
   "item_aghsfort_viper_viper_strike_damage",
}

--Weaver
item_aghsfort_weaver_the_swarm_flat_armor_reduction = item_small_scepter_fragment
item_aghsfort_weaver_the_swarm_flat_damage = item_small_scepter_fragment
item_aghsfort_weaver_the_swarm_percent_cooldown = item_small_scepter_fragment
item_aghsfort_weaver_shukuchi_flat_damage = item_small_scepter_fragment
item_aghsfort_weaver_shukuchi_duration = item_small_scepter_fragment
item_aghsfort_weaver_geminate_attack_cooldown = item_small_scepter_fragment
item_aghsfort_weaver_geminate_attack_flat_bonus_damage = item_small_scepter_fragment
item_aghsfort_weaver_time_lapse_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_weaver" ] =
{
   "item_aghsfort_weaver_the_swarm_flat_armor_reduction",
   "item_aghsfort_weaver_the_swarm_flat_damage",
   "item_aghsfort_weaver_the_swarm_percent_cooldown",
   "item_aghsfort_weaver_shukuchi_flat_damage",
   "item_aghsfort_weaver_shukuchi_duration",
   "item_aghsfort_weaver_geminate_attack_cooldown",
   "item_aghsfort_weaver_geminate_attack_flat_bonus_damage",
   "item_aghsfort_weaver_time_lapse_cooldown",
}

--Winter Wyvern
item_aghsfort_winter_wyvern_arctic_burn_flat_damage = item_small_scepter_fragment
item_aghsfort_winter_wyvern_arctic_burn_flat_duration = item_small_scepter_fragment
item_aghsfort_winter_wyvern_splinter_blast_flat_radius = item_small_scepter_fragment
item_aghsfort_winter_wyvern_splinter_blast_flat_damage = item_small_scepter_fragment
item_aghsfort_winter_wyvern_cold_embrace_flat_heal_percentage = item_small_scepter_fragment
item_aghsfort_winter_wyvern_cold_embrace_pct_cooldown = item_small_scepter_fragment
item_aghsfort_winter_wyvern_winters_curse_flat_duration = item_small_scepter_fragment
item_aghsfort_winter_wyvern_winters_curse_pct_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_winter_wyvern" ] =
{
   "item_aghsfort_winter_wyvern_arctic_burn_flat_damage",
   "item_aghsfort_winter_wyvern_arctic_burn_flat_duration",
   "item_aghsfort_winter_wyvern_splinter_blast_flat_radius",
   "item_aghsfort_winter_wyvern_splinter_blast_flat_damage",
   "item_aghsfort_winter_wyvern_cold_embrace_flat_heal_percentage",
   "item_aghsfort_winter_wyvern_cold_embrace_pct_cooldown",
   "item_aghsfort_winter_wyvern_winters_curse_flat_duration",
   "item_aghsfort_winter_wyvern_winters_curse_pct_cooldown",
}

--WD
item_aghsfort_witch_doctor_voodoo_restoration_manacost = item_small_scepter_fragment
item_aghsfort_witch_doctor_voodoo_restoration_flat_heal = item_small_scepter_fragment
item_aghsfort_witch_doctor_paralyzing_cask_flat_damage = item_small_scepter_fragment
item_aghsfort_witch_doctor_paralyzing_cask_flat_bounces = item_small_scepter_fragment
item_aghsfort_witch_doctor_maledict_flat_ticks = item_small_scepter_fragment
item_aghsfort_witch_doctor_maledict_flat_max_bonus_damage = item_small_scepter_fragment
item_aghsfort_witch_doctor_death_ward_flat_damage = item_small_scepter_fragment
item_aghsfort_witch_doctor_death_ward_flat_channel_duration = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_witch_doctor" ] =
{
   "item_aghsfort_witch_doctor_voodoo_restoration_manacost",
   "item_aghsfort_witch_doctor_voodoo_restoration_flat_heal",
   "item_aghsfort_witch_doctor_paralyzing_cask_flat_damage",
   "item_aghsfort_witch_doctor_paralyzing_cask_flat_bounces",
   "item_aghsfort_witch_doctor_maledict_flat_ticks",
   "item_aghsfort_witch_doctor_maledict_flat_max_bonus_damage",
   "item_aghsfort_witch_doctor_death_ward_flat_damage",
   "item_aghsfort_witch_doctor_death_ward_flat_channel_duration",
}

-- Void Spirit
item_aghsfort_void_spirit_aether_remnant_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_void_spirit_aether_remnant_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_dissimilate_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_void_spirit_dissimilate_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_base_absorb = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_absorb_per_unit = item_small_scepter_fragment
item_aghsfort_void_spirit_astral_step_pop_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_astral_step_max_travel_distance = item_small_scepter_fragment
item_aghsfort_void_spirit_astral_step_charge_restore_time = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_void_spirit" ] =
{
   "item_aghsfort_void_spirit_aether_remnant_mana_cost_cooldown",
   "item_aghsfort_void_spirit_aether_remnant_damage",
   "item_aghsfort_void_spirit_dissimilate_mana_cost_cooldown",
   "item_aghsfort_void_spirit_dissimilate_damage",
   "item_aghsfort_void_spirit_resonant_pulse_mana_cost_cooldown",
   "item_aghsfort_void_spirit_resonant_pulse_damage",
   "item_aghsfort_void_spirit_resonant_pulse_base_absorb",
   "item_aghsfort_void_spirit_resonant_pulse_absorb_per_unit",
   "item_aghsfort_void_spirit_astral_step_pop_damage",
   "item_aghsfort_void_spirit_astral_step_max_travel_distance",
   "item_aghsfort_void_spirit_astral_step_charge_restore_time",
}

