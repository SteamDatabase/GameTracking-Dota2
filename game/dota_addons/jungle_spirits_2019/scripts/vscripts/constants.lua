
--------------------------------------------------------------------------------
-- Game end states
--------------------------------------------------------------------------------

_G.NOT_ENDED = 0
_G.VICTORIOUS = 1
_G.DEFEATED = 2

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

_G.DOTA_MAX_ABILITIES = 30
_G.ABILITY_NOT_LEARNABLE = 4

_G.TIME_BEFORE_FIRST_MARCH = 300
_G.TIME_BETWEEN_TEAM_MARCHES = 75
_G.TIME_AFTER_MARCH_PAIR = 270
_G.SPIRIT_LIFETIME_PER_MARCH = 150
_G.SPIRIT_DEATH_TIMER = 6
_G.SPIRIT_TIME_BETWEEN_BRANCH_ABILITIES = 20.0

_G.TIME_PER_GEM_SPAWN = 120
_G.GEM_SPAWN_WARNING_TIME = 20
_G.GEM_DAMAGE_COOLDOWN = 3.0

_G.HIGHEST_BEAST_DISADVANTAGE = 5
_G.MIN_ESSENCE_MULTIPLIER = 1.0
_G.MAX_ESSENCE_MULTIPLIER = 2.0
_G.MAX_ESSENCE_CAP = 500

_G.MOROKAI_MAX_LEVEL = 30

_G.HERO_EXPERIENCE_GAIN_MULTIPLIER = 1.3
_G.HERO_GOLD_GAIN_MULTIPLIER = 1.3

--------------------------------------------------------------------------------

_G.SPIRIT_BRANCH_JUNGLE = 1
_G.SPIRIT_BRANCH_STORM = 2
_G.SPIRIT_BRANCH_VOLCANO = 3

_G.SPIRIT_ABILITIES_BY_TIER = {}
SPIRIT_ABILITIES_BY_TIER[SPIRIT_BRANCH_JUNGLE] =
{
	"special_bonus_unique_jungle_spirit_movement_speed",

	"jungle_spirit_jungle_building_regeneration",

	"morokai_jungle_heal_beam",

	"special_bonus_unique_jungle_spirit_spell_lifesteal",

	"jungle_spirit_jungle_lumber_lock",

	"special_bonus_unique_morokai_jungle_heal_beam_beam_heal",

	"special_bonus_unique_jungle_spirit_evasion",

	"special_bonus_unique_morokai_jungle_heal_beam_treant_level",

	"special_bonus_unique_jungle_spirit_bonus_health",

	"special_bonus_unique_morokai_jungle_heal_beam_third_beam",
}

SPIRIT_ABILITIES_BY_TIER[SPIRIT_BRANCH_STORM] =
{
	"special_bonus_unique_jungle_spirit_cooldown_reduction",

	"jungle_spirit_river_rejuvenation",

	"jungle_spirit_storm_cyclone",

	"special_bonus_unique_jungle_spirit_magic_resistance",

	"jungle_spirit_storm_multicast",

	"special_bonus_unique_jungle_spirit_storm_cyclone_damage",

	"special_bonus_unique_morokai_range_attack_aoe_damage",
	
	"special_bonus_unique_jungle_spirit_storm_cyclone_debuff_duration",	

	"special_bonus_unique_jungle_spirit_spell_amplify",

	"special_bonus_unique_jungle_spirit_storm_cyclone_projectiles",
}

SPIRIT_ABILITIES_BY_TIER[SPIRIT_BRANCH_VOLCANO] =
{
	"special_bonus_unique_jungle_spirit_attack_damage",

	"jungle_spirit_volcano_damage_block",

	"junglespirit_volcano_eruption",

	"special_bonus_unique_jungle_spirit_health_regen",

	"jungle_spirit_volcano_fire_strike",

	"special_bonus_unique_jungle_spirit_volcano_splinter",
	
	"special_bonus_unique_jungle_spirit_melee_stun_duration",

	"special_bonus_unique_jungle_spirit_volcano_damage_bonus",

	"special_bonus_unique_jungle_spirit_bonus_armor",
	
	"special_bonus_unique_jungle_spirit_volcano_multitarget",
}

_G.SPIRIT_GLOBAL_ABILITIES = {}
--SPIRIT_GLOBAL_ABILITIES[ SPIRIT_BRANCH_JUNGLE ] = 	"jungle_spirit_team_windrun"
--SPIRIT_GLOBAL_ABILITIES[ SPIRIT_BRANCH_STORM ] = "jungle_spirit_team_frost_armor"
--SPIRIT_GLOBAL_ABILITIES[ SPIRIT_BRANCH_VOLCANO ] = "jungle_spirit_team_heal"

_G.GEMS_REQUIRED_PCT = 1.0 --0.2

_G.IS_MAJOR_TIER = 
{
	true,
	false,
	false,
	true,
	false,
	false,
	true,
	false,
	false,
	true,
}

_G.CUPCAKES_REQUIRED_PER_BRANCH_LEVEL =
{
	-- For now we make level 1 the same cost as level 2 due to shenanigans that happen at beast level 1
	25, -- Cost @ Jungle Spirit Level 1
	25, -- Cost @ Jungle Spirit Level 2
	35, -- Cost @ Jungle Spirit Level 3
	40, -- Cost @ Jungle Spirit Level 4
	50, -- Cost @ Jungle Spirit Level 5
	60, -- Cost @ Jungle Spirit Level 6
	75, -- Cost @ Jungle Spirit Level 7
	80, -- Cost @ Jungle Spirit Level 8
	85, -- Cost @ Jungle Spirit Level 9
	90, -- Cost @ Jungle Spirit Level 10
	95, -- Cost @ Jungle Spirit Level 11
	100, -- Cost @ Jungle Spirit Level 12
	110, -- Cost @ Jungle Spirit Level 13
	115, -- Cost @ Jungle Spirit Level 14
	120, -- Cost @ Jungle Spirit Level 15
	125, -- Cost @ Jungle Spirit Level 16
	130, -- Cost @ Jungle Spirit Level 17
	135, -- Cost @ Jungle Spirit Level 18
	140, -- Cost @ Jungle Spirit Level 19
	145, -- Cost @ Jungle Spirit Level 20
	150, -- Cost @ Jungle Spirit Level 21
	155, -- Cost @ Jungle Spirit Level 22
	160, -- Cost @ Jungle Spirit Level 23
	165, -- Cost @ Jungle Spirit Level 24
	170, -- Cost @ Jungle Spirit Level 25
	175, -- Cost @ Jungle Spirit Level 26
	180, -- Cost @ Jungle Spirit Level 27
	185, -- Cost @ Jungle Spirit Level 28
	190, -- Cost @ Jungle Spirit Level 29
	200, -- Cost @ Jungle Spirit Level 30
}

_G.CUPCAKES_COST_PER_TEAM_SHARED_ABILITY = 
{
	-- Scaling cost assumes that each branch's associated team shared ability gets stronger
	-- as you progress in its branch
	5,
	6,
	7,
	8,
	10,
	11,
	12,
	13,
	15,
	16,
	17,
	18,
	25,
}

_G.NETTABLE_SEND_GEM_CONSTANTS = {}
NETTABLE_SEND_GEM_CONSTANTS["gems_required_pct"] = GEMS_REQUIRED_PCT
NETTABLE_SEND_GEM_CONSTANTS["cupcakes_required_per_branch_level"] = CUPCAKES_REQUIRED_PER_BRANCH_LEVEL
NETTABLE_SEND_GEM_CONSTANTS["cupcakes_cost_per_team_shared_ability"] = CUPCAKES_COST_PER_TEAM_SHARED_ABILITY
NETTABLE_SEND_GEM_CONSTANTS["major_tiers"] = IS_MAJOR_TIER

--------------------------------------------------------------------------------

_G.GAME_DIFFICULTY_FACTOR = 0

--------------------------------------------------------------------------------

_G.RADIANT_SPIRIT_SPAWN_POS = Vector( -6840, -6300, 0 )
_G.DIRE_SPIRIT_SPAWN_POS = Vector( 6700, 6100, 0 )

_G.LANE_SPECIFIER_STRING =
{
	"top",
	"mid",
	"bot"
}

_G.GEM_DROP_LOCATIONS =
{
	-- Dire jungle top
	Vector( -5280, 4544, 256 ),
	Vector( -4386, 4794, 256 ),
	Vector( -5260, 3814, 256 ),
	Vector( -3267, 4753, 256 ),
	Vector( -4012, 3877, 256 ),
	Vector( -2282, 3714, 256 ),
	Vector( -722, 1310, 256 ),
	Vector( -4798, 3881, 256 ),
	Vector( -3356, 5362, 256 ),

	-- Radiant jungle top
	Vector( -4458, 1378, 256 ),
	Vector( -3013, 251, 384 ),
	Vector( -2149, 247, 256 ),

	-- Lane top
	Vector( -5500, 2937, 256 ),
	Vector( -6200, 2953, 256 ),
	Vector( -6238, 3678, 256 ),
	Vector( -6228, 4481, 256 ),
	Vector( -5985, 5287, 256 ),
	Vector( -7142, 4457, 256 ), -- tight

	-- Lane mid
	Vector( -1647, -210, 256 ),
	Vector( 1133, -562, 256 ),
	Vector( 222, -1398, 256 ),

	-- Lane bot
	Vector( 5935, -5132, 256 ),
	Vector( 6298, -4232, 256 ),
	Vector( 6216, -3308, 256 ),
	Vector( 5474, -2928, 256 ),
	Vector( 7246, -4145, 256 ), -- tight

	-- River top
	Vector( -4472, 2778, 128 ),
	Vector( -3083, 3404, 128 ),
	Vector( -3587, 2581, 128 ),
	Vector( -3248, 1770, 128 ), -- tight
	Vector( -2133, 2834, 128 ), -- tight
	Vector( -2263, 994, 128 ),
	Vector( -1550, 1963, 128 ), -- tight

	-- River mid
	Vector( -1698, 1143, 128 ),
	Vector( -1123, 477, 128 ),
	Vector( -515, -324, 128 ),
	Vector( 364, -787, 128 ), -- tight
	Vector( 1452, -1335, 128 ), -- tight
	Vector( -374, -508, 128 ),
	Vector( -850, -61, 128 ),

	-- River bot
	Vector( 2337, -1828, 128 ),
	Vector( 3413, -2412, 128 ),
	Vector( 4345, -2694, 128 ), -- tight
	Vector( 3698, -2893, 128 ),

	-- Radiant jungle bot
	Vector( 4748, -5070, 256 ), -- tight
	Vector( 5258, -4261, 256 ),
	Vector( 5045, -3731, 256 ),
	Vector( 4198, -4105, 256 ),
	Vector( 3294, -3659, 256 ),
	Vector( 3445, -5101, 256 ),
	Vector( 2736, -3380, 256 ),
	Vector( 2226, -2788, 256 ),
	Vector( 1185, -2315, 256 ),
	Vector( 353, -2292, 256 ),

	-- Dire jungle bot
	Vector( 4226, -1784, 256 ),
	Vector( 2377, -1075, 256 ),
	Vector( 3992, -816, 256 ),
	Vector( 1741, -737, 256 ), -- tight
}

_G.SPECIAL_UNITS =
{
	"npc_dota_roshan",
	"npc_dota_gem_pinata",
	"npc_dota_creature_bonus_chicken",
	"npc_dota_jungle_spirit_summon_1",
	"npc_dota_jungle_spirit_summon_2",
}

--------------------------------------------------------------------------------

_G.CREATURE_GEM_DROP_MODIFIER_CHANCE = 20
_G.CREATURE_GEM_DROP_MODIFIER_STACK = 7

_G.ROSHAN_GEMS_COUNT = 26

_G.GEM_PINATA_GEM_DROP_MODIFIER_STACK = 33
_G.GEM_MEGA_PINATA_GEM_DROP_MODIFIER_STACK = 72

_G.BUILDING_GEM_DROP_AMOUNT = 13

_G.GEM_BONUS_GAIN_PER_MINUTE = 0.325
_G.GEM_AMOUNT_FUZZ_RANGE = 0.0

_G.SMALL_GEM_MODELSCALE = 0.8
_G.MEDIUM_GEM_MODELSCALE = 1.3
_G.BIG_GEM_MODELSCALE = 1.8

_G.GOLD_BAG_MODELSCALE = 1.2

_G.GEMS_PER_SMALL_ITEM = 1
_G.GEMS_PER_MEDIUM_ITEM = 5
_G.GEMS_PER_BIG_ITEM = 20

_G.GEMS_PCT_LOST_ON_DEATH_MAXIMUM = 0.5
_G.GEMS_PCT_LOST_ON_DEATH_MINIMUM = 0.25

_G.GEM_EXPIRE_TIME = 15
_G.PINATA_EXPIRE_TIME = 60

_G.BATTLE_POINTS_PER_ITEM = 100
_G.BATTLE_POINTS_PER_WIN = 250
_G.BP_ITEMS_PER_CARE_PACKAGE = 1

_G.BATTLE_POINTS_CARE_PACKAGE_INTERVAL = 5

_G.BATTLE_POINT_REWARD_TIERS =
{
	-- [Tier] = { szItemName, nBattlePoints, fModelScale }
	[1] = { "item_battle_points", 125, 1.2 },
	[2] = { "item_battle_points_250", 250, 1.45 },
	[3] = { "item_battle_points_500", 500, 1.75 },
	[4] = { "item_battle_points_2000", 2000, 2.15 },
	[5] = { "item_battle_points_5000", 5000, 2.6 },
}

--------------------------------------------------------------------------------

_G.ANNOUNCER_COOLDOWN = 4.0
_G.ANNOUNCER_MONOLOGUE_COOLDOWN = 60.0
_G.ANNOUNCER_DELAY = 1.0
_G.ANNOUNCER_MARCH_DELAY = 7.5
_G.ANNOUNCER_CARE_PACKAGE_DELAY = 2.0

--------------------------------------------------------------------------------
