
_G.TEAM_SPECTATOR = 1

-- Game States
_G.NEMESTICE_GAMESTATE_PREGAME = 1
_G.NEMESTICE_GAMESTATE_PREP_TIME = 5
_G.NEMESTICE_GAMESTATE_IN_PROGRESS = 10
_G.NEMESTICE_GAMESTATE_SUDDEN_DEATH = 15
_G.NEMESTICE_GAMESTATE_POSTLOAD_PHASE = 50
_G.NEMESTICE_GAMESTATE_GAMEOVER = 100

_G.NEMESTICE_PLAYERS_PER_TEAM = 5
_G.NEMESTICE_THINK_INTERVAL = 0.25

_G.NEMESTICE_NUM_ROUNDS = 10 -- NOTE; If you increase this, you must increase all ability specials for abilities that are SetLevel'd to the round number!
_G.NEMESTICE_END_TIME = 999 * 60.0 -- i.e. disabled

_G.NEMESTICE_TOWER_HEALTH_TICK_RATE = 10.0

_G.NEMESTICE_METEOR_ENERGY_DURATION = 90.0

_G.NEMESTICE_METEOR_EXCLUDE_RADIUS = 1200

_G.NEMESTICE_BAN_PHASE_TIME = 8.0
_G.NEMESTICE_PICK_PHASE_TIME = 30.0
_G.NEMESTICE_STRATEGY_PHASE_TIME = 20.0

-- Power level of creeps/towers/ability buildings upgrade every time  "round" ends.
_G.NEMESTICE_ROUND_TIME = GlobalSys:CommandLineInt( "-nemestice_roundtimeoverride", 180 )

_G.NEMESTICE_PREP_TIME = 30
_G.NEMESTICE_POSTLOAD_TIME = GlobalSys:CommandLineInt( "-nemestice_first_round_setup_time_override", 21 )

_G.NEMESTICE_BUYBACK_COOLDOWN = 300.0

_G.NEMESTICE_IN_GAME_SCOREBOARD_DELTA_INDICATOR_DURATION = 15

_G.NEMESTICE_GLYPH_INITIAL_COOLDOWN = 0

_G.NEMESTICE_SCOREBOARD_TOWER_ORDER =
{
	[ 1 ] = "npc_dota_tower_dire_top",
	[ 2 ] = "npc_dota_tower_dire_mid_forward",
	[ 3 ] = "npc_dota_tower_dire_mid_back",
	[ 4 ] = "npc_dota_tower_dire_bot",
	[ 5 ] = "npc_dota_tower_radiant_top",
	[ 6 ] = "npc_dota_tower_radiant_mid_back",
	[ 7 ] = "npc_dota_tower_radiant_mid_forward",
	[ 8 ] = "npc_dota_tower_radiant_bot"
}

_G.NEMESTICE_BUILDING_HEALTH_BUFF_PCT =
{
	0,   -- 0-3
	22,  -- 3-6
	43,  -- 6-9
	65,  -- 9-12
	87,  -- 12-15
	108, -- 15-18
	130, -- 18-21
	152, -- 21-24
	173, -- 24-27
	195, -- 27+
}

_G.NEMESTICE_BUILDING_HEALTH_BONUS =
{
	1500,	-- 1 tower remaining
	1000,	-- 2 towers remaining
	500,	-- 3 towers remaining
	0,		-- 4 towers remaining
}

_G.NEMESTICE_TOWER_DMG_BUFF_PCT = 
{
	0, -- 0-3
	38, -- 3-6
	76, -- 6-9
	114, -- 9-12
	152, -- 12-15
	190, -- 15-18
	228, -- 18-21
	266, -- 21-24
	304, -- 24-27
	342, -- 27+
}

_G.NEMESTICE_TOWER_ARMOR_BONUS = 
{
	0, -- 0-3
	1, -- 3-6
	2, -- 6-9
	3, -- 9-12
	4, -- 12-15
	5, -- 15-18
	6, -- 18-21
	7, -- 21-24
	8, -- 24-27
	9, -- 27+
}

_G.NEMESTICE_TOWER_REGEN_DISABLE_COUNT = 4
_G.NEMESTICE_TOWER_REGEN_PCT_PER_SEC = 0.25
_G.NEMESTICE_TOWER_REGEN_PEACE_TIME = 20.0

_G.NEMESTICE_TOWER_DESTRUCTION_HEAL_PERCENT = 40
_G.NEMESTICE_TOWER_DESTRUCTION_HEAL_DURATION = 10
_G.NEMESTICE_TOWER_DESTRUCTION_ARMOR_BONUS = 5

_G.NEMESTICE_TOWER_PROTECTION_ARMOR = 
{
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5
}
_G.NEMESTICE_TOWER_PROTECTION_REGEN = 
{
	5.0,
	6.5,
	8.0,
	10.0,
	12.0,
	14.25,
	17.0,
	20.0,
	23.0,
	26.5
}

_G.NEMESTICE_TOWER_DEVELOPER_NAME =
{
	[ "1" ] = "Southwest",
	[ "2" ] = "West",
	[ "3" ] = "South",
	[ "4" ] = "North",
	[ "5" ] = "Northwest",
	[ "6" ] = "Southeast",
	[ "7" ] = "East",
	[ "8" ] = "Northeast",
	[ "m" ] = "[ METEOR ]"
}

_G.NEMESTICE_TOWER_DEVELOPER_ORDER =
{
	[ 1 ] = "5",
	[ 2 ] = "4",
	[ 3 ] = "8",
	[ 4 ] = "7",
	[ 5 ] = "2",
	[ 6 ] = "1",
	[ 7 ] = "3",
	[ 8 ] = "6"
}

_G.NEMESTICE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE = 10

_G.NEMESTICE_HERO_RESPAWN_TIME_PERCENTAGE_DECREASE = 0.62
_G.NEMESTICE_HERO_RESPAWN_TIME_CONSTANT = 14.0
_G.NEMESTICE_HERO_RESPAWN_TIME_EXTRA_TIME_TIME_LIMIT = 20.0 * 60.0
_G.NEMESTICE_HERO_RESPAWN_TIME_EXTRA_TIME_PER_SECOND_PAST_LIMIT = 0.05

_G.NEMESTICE_STARTING_TIME_OF_DAY = 0.251

_G.NEMESTICE_WAVE_WARNING_TIME = 5.0
_G.NEMESTICE_SPAWN_DELAY = 45.0

_G.NEMESTICE_GOLD_PER_TICK = 1

_G.NEMESTICE_REWARD_XP_MULT_DEAD = 1.0
_G.NEMESTICE_REWARD_GOLD_MULT_DEAD = 1.0

_G.NEMESTICE_HERO_KILL_XP_MULTIPLIER_SELF = 0.36
_G.NEMESTICE_HERO_KILL_XP_MULTIPLIER_OTHERS = 0.16
_G.NEMESTICE_HERO_KILL_GOLD_MULTIPLIER = 1.0

_G.NEMESTICE_REWARD_OUT_OF_BAND_GOLD =
{
	1.0, -- 0-3
	1.0, -- 3-6
	1.0, -- 6-9
	1.0, -- 9-12
	1.0, -- 12-15
	1.0, -- 15-18
	1.0, -- 18-21
	1.0, -- 21-24
	1.0, -- 24-27
	1.0, -- 27+
}
_G.NEMESTICE_REWARD_OUT_OF_BAND_XP =
{
	0.7, -- 0-3
	0.7, -- 3-6
	0.7, -- 6-9
	0.7, -- 9-12
	0.7, -- 12-15
	0.7, -- 15-18
	0.7, -- 18-21
	0.7, -- 21-24
	0.7, -- 24-27
	0.7, -- 27+
}

_G.NEMESTICE_REWARD_MULTIPLIER_GOLD = _G.NEMESTICE_SPAWN_DELAY / 60.0 * 0.9 -- basic multiplier to gold
_G.NEMESTICE_REWARD_MULTIPLIER_XP = _G.NEMESTICE_SPAWN_DELAY / 60.0 * 1.0 -- basic multiplier to xp
-- when no hero nearby
_G.NEMESTICE_REWARD_BASE_GOLD = 0.5
_G.NEMESTICE_REWARD_BASE_XP = 0.5
-- when hero is nearby but not lasthitting
_G.NEMESTICE_REWARD_HERO_RADIUS = 1000
_G.NEMESTICE_REWARD_NEAR_GOLD = 1.0
_G.NEMESTICE_REWARD_NEAR_XP = 1.0
-- when hero lasthits the creep
_G.NEMESTICE_REWARD_LASTHIT_GOLD = 4.0
_G.NEMESTICE_REWARD_LASTHIT_XP = 2.0
_G.NEMESTICE_REWARD_LASHIT_GOLD_SELF_PORTION = 0.75
_G.NEMESTICE_REWARD_LASHIT_XP_SELF_PORTION = 0.5

-- These ignore other multipliers, since by definition it's a hero lasthit
_G.NEMESTICE_REWARD_DENY_MULTIPLIER_GOLD = 0
_G.NEMESTICE_REWARD_DENY_MULTIPLIER_XP = 0.25

_G.NEMESTICE_WAVE_REWARD_GOLD_BASE = 300
_G.NEMESTICE_WAVE_REWARD_GOLD_POW = 3
_G.NEMESTICE_WAVE_REWARD_GOLD_SQRT = 2
_G.NEMESTICE_WAVE_REWARD_GOLD_COEFF = 60
_G.NEMESTICE_WAVE_REWARD_GOLD_POW2_START = 20
_G.NEMESTICE_WAVE_REWARD_GOLD_POW2 = 3
_G.NEMESTICE_WAVE_REWARD_GOLD_COEFF2 = -0.5
_G.NEMESTICE_WAVE_REWARD_GOLD_MIN_ADD = 300

_G.NEMESTICE_WAVE_REWARD_XP_BASE = 450
_G.NEMESTICE_WAVE_REWARD_XP_POW = 1
_G.NEMESTICE_WAVE_REWARD_XP_SQRT = 0
_G.NEMESTICE_WAVE_REWARD_XP_COEFF = 65
_G.NEMESTICE_WAVE_REWARD_XP_POW2_START = 23
_G.NEMESTICE_WAVE_REWARD_XP_POW2 = 3
_G.NEMESTICE_WAVE_REWARD_XP_SQRT2 = 0
_G.NEMESTICE_WAVE_REWARD_XP_COEFF2 = 33

--
_G.NEMESTICE_GOLD_REASON_LABELS =
{
	[DOTA_ModifyGold_Unspecified] = "unspecified",
	[DOTA_ModifyGold_Death] = "death",
	[DOTA_ModifyGold_Buyback] = "buyback",
	[DOTA_ModifyGold_PurchaseConsumable] = "consumable",
	[DOTA_ModifyGold_PurchaseItem] = "item",
	[DOTA_ModifyGold_AbandonedRedistribute] = "abandonredist",
	[DOTA_ModifyGold_SellItem] = "sellitem",
	[DOTA_ModifyGold_AbilityCost] = "abilitycost",
	[DOTA_ModifyGold_CheatCommand] = "cheat",
	[DOTA_ModifyGold_SelectionPenalty] = "selectionpenalty",
	[DOTA_ModifyGold_GameTick] = "tick",
	[DOTA_ModifyGold_Building] = "building",
	[DOTA_ModifyGold_HeroKill] = "hero",
	[DOTA_ModifyGold_CreepKill] = "creep",
	[DOTA_ModifyGold_NeutralKill] = "neutral",
	[DOTA_ModifyGold_RoshanKill] = "roshan",
	[DOTA_ModifyGold_CourierKill] = "courier",
	[DOTA_ModifyGold_BountyRune] = "bounty",
	[DOTA_ModifyGold_SharedGold] = "shared",
	[DOTA_ModifyGold_AbilityGold] = "ability",
	[DOTA_ModifyGold_WardKill] = "ward",
}


_G.NEMESTICE_TOWER_MODEL_SCALE_PER_UPGRADE = 0.02
_G.NEMESTICE_TOWER_DESTRUCTION_DAMAGE_RADIUS = 950

_G.NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_R = 0.8
_G.NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_G = 0.5
_G.NEMESTICE_EMBERCHARGE_COUNTER_TEXT_COLOR_B = 0.8

-- These values are referenced indirectly by nemestice_hud.css
_G.NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER = 0
_G.NEMESTICE_METEOR_UPGRADE_TYPE_TOWER   = 1
_G.NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY = 2


_G.NEMESTICE_METEOR_UPGRADE_LIST =
{
	-- Spawners
	{
		szName = "tower_upgrade_spawn_melee_creeps",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER,
		nCost = 10,
	},
	{
		szName = "tower_upgrade_spawn_ranged_creeps",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER,
		nCost = 10,
	},
	{
		szName = "tower_upgrade_spawn_kobolds",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER,
		nCost = 15,
	},
	{
		szName = "tower_upgrade_spawn_hellbears",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER,
		nCost = 50,
	},
	{
		szName = "tower_upgrade_spawn_troll_priests",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER,
		nCost = 30,
	},

	-- Tower Upgrades
	{
		szName = "tower_upgrade_tower_aspd",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_TOWER,
		nCost = 20,
	},
	{
		szName = "tower_upgrade_tower_multishot",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_TOWER,
		nCost = 40,
	},
	{
		szName = "tower_upgrade_tower_skadi",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_TOWER,
		nCost = 30,
	},

	-- Tower Active Abilities
	{
		szName = "tower_upgrade_tower_shrine",
		nType = NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY,
		nCost = 20,
	},
}

_G.NEMESTICE_METEOR_UPGRADES = {}
for _,upgrade in ipairs( NEMESTICE_METEOR_UPGRADE_LIST ) do
	NEMESTICE_METEOR_UPGRADES[upgrade.szName] = upgrade
end

_G.NEMESTICE_TOWER_TEXT_MAP =
{
	columns = 50,
	rows = 15
}

_G.NEMESTICE_TOWER_OWNER_SHORT_NAMES =
{
	[DOTA_TEAM_GOODGUYS] = "Radiant",
	[DOTA_TEAM_BADGUYS] = "Dire",
	[DOTA_TEAM_CUSTOM_1] = "Destroyed",
}

_G.NEMESTICE_TOWER_UPGRADE_SET = 
{
	"tower_upgrade_spawn_kobolds",
	"tower_upgrade_spawn_hellbears",
	"tower_upgrade_spawn_troll_priests",
	"tower_upgrade_tower_shrine",
}

_G.NEMESTICE_TOWER_AUTO_UPGRADES =
{
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
	{ "tower_upgrade_add_lane_creeps" },
}

_G.NEMESTICE_TOWER_AUTO_UPGRADES_ON_DESTROY =
{
	{ "tower_upgrade_spawn_kobolds" },
	{ "tower_upgrade_spawn_troll_priests" },
	{ "tower_upgrade_spawn_hellbears" },
}

_G.NEMESTICE_TOWER_GRAPH =
{
	npc_dota_tower_dire_top =  { "npc_dota_tower_dire_mid_forward", "npc_dota_tower_radiant_top" },
	npc_dota_tower_dire_mid_forward = { "npc_dota_tower_dire_mid_back", "npc_dota_tower_dire_top", "npc_dota_tower_radiant_mid_back" },
	npc_dota_tower_dire_mid_back = { "npc_dota_tower_dire_mid_forward", "npc_dota_tower_dire_bot", "npc_dota_tower_radiant_mid_forward" },
	npc_dota_tower_dire_bot = { "npc_dota_tower_dire_mid_back", "npc_dota_tower_radiant_bot" },
	npc_dota_tower_radiant_top =  { "npc_dota_tower_radiant_mid_back", "npc_dota_tower_dire_top" },
	npc_dota_tower_radiant_mid_back = { "npc_dota_tower_radiant_mid_forward", "npc_dota_tower_radiant_top", "npc_dota_tower_dire_mid_forward" },
	npc_dota_tower_radiant_mid_forward = { "npc_dota_tower_radiant_mid_back", "npc_dota_tower_radiant_bot", "npc_dota_tower_dire_mid_back" },
	npc_dota_tower_radiant_bot = { "npc_dota_tower_radiant_mid_forward", "npc_dota_tower_dire_bot" },
}

_G.NEMESTICE_TOWER_LANES =
{
	npc_dota_tower_dire_top =  { "npc_dota_tower_radiant_top" },
	npc_dota_tower_dire_mid_forward = { "npc_dota_tower_radiant_mid_back" },
	npc_dota_tower_dire_mid_back = { "npc_dota_tower_radiant_mid_forward" },
	npc_dota_tower_dire_bot = { "npc_dota_tower_radiant_bot" },
	npc_dota_tower_radiant_top =  { "npc_dota_tower_dire_top" },
	npc_dota_tower_radiant_mid_back = { "npc_dota_tower_dire_mid_forward" },
	npc_dota_tower_radiant_mid_forward = { "npc_dota_tower_dire_mid_back" },
	npc_dota_tower_radiant_bot = { "npc_dota_tower_dire_bot" },
}

_G.NEMESTICE_TOWER_GRAPH_FALLBACK =
{
	npc_dota_tower_dire_top =  { "npc_dota_tower_radiant_mid_back", "npc_dota_tower_radiant_mid_forward", "npc_dota_tower_radiant_bot" },
	npc_dota_tower_dire_mid_forward = { "npc_dota_tower_radiant_mid_forward", "npc_dota_tower_radiant_top", "npc_dota_tower_radiant_bot" },
	npc_dota_tower_dire_mid_back = { "npc_dota_tower_radiant_mid_back", "npc_dota_tower_radiant_bot", "npc_dota_tower_radiant_top" },
	npc_dota_tower_dire_bot = { "npc_dota_tower_radiant_mid_forward", "npc_dota_tower_radiant_mid_back", "npc_dota_tower_radiant_top" },
	npc_dota_tower_radiant_top =  { "npc_dota_tower_dire_mid_forward", "npc_dota_tower_dire_mid_back", "npc_dota_tower_dire_bot" },
	npc_dota_tower_radiant_mid_back = { "npc_dota_tower_dire_mid_back", "npc_dota_tower_dire_top", "npc_dota_tower_dire_bot" },
	npc_dota_tower_radiant_mid_forward = { "npc_dota_tower_dire_mid_forward", "npc_dota_tower_dire_bot", "npc_dota_tower_dire_top" },
	npc_dota_tower_radiant_bot = { "npc_dota_tower_dire_mid_back", "npc_dota_tower_dire_mid_forward", "npc_dota_tower_dire_top" },
}

_G.NEMESTICE_TOWER_TEAMS = 
{
	npc_dota_tower_dire_top = DOTA_TEAM_BADGUYS,
	npc_dota_tower_dire_mid_forward = DOTA_TEAM_BADGUYS,
	npc_dota_tower_dire_mid_back = DOTA_TEAM_BADGUYS,
	npc_dota_tower_dire_bot = DOTA_TEAM_BADGUYS,
	npc_dota_tower_radiant_top = DOTA_TEAM_GOODGUYS,
	npc_dota_tower_radiant_mid_back = DOTA_TEAM_GOODGUYS,
	npc_dota_tower_radiant_mid_forward = DOTA_TEAM_GOODGUYS,
	npc_dota_tower_radiant_bot = DOTA_TEAM_GOODGUYS,
}

_G.NEMESTICE_TOWER_NICKNAMES =
{
	npc_dota_tower_dire_top = { "dire_top", "northwest", "nw", "d1" },
	npc_dota_tower_dire_mid_forward = { "dire_mid_forward", "north", "n", "d2" },
	npc_dota_tower_dire_mid_back = { "dire_mid_back", "northeast", "ne", "d3" },
	npc_dota_tower_dire_bot = { "dire_bot", "east", "e", "d4" },
	npc_dota_tower_radiant_top = { "radiant_top", "west", "w", "r1" },
	npc_dota_tower_radiant_mid_back = { "radiant_mid_back", "southwest", "sw", "r2" },
	npc_dota_tower_radiant_mid_forward = { "radiant_mid_forward", "south", "s", "r3" },
	npc_dota_tower_radiant_bot = { "radiant_bot", "southeast", "se", "r4" },
}

_G.NEMESTICE_SMALL_METEOR_CRASH_SITE_INITIAL_DELAY = 0.0
_G.NEMESTICE_SMALL_METEOR_CRASH_SITE_INTERVAL_MIN = 30.0
_G.NEMESTICE_SMALL_METEOR_CRASH_SITE_INTERVAL_MAX = 90.0
_G.NEMESTICE_SMALL_METEOR_CRASH_SITE_INTERVAL_PER_ROUND_DECREASE = 0.05

_G.NEMESTICE_MEDIUM_METEOR_CRASH_SITE_INITIAL_DELAY = 0.0
_G.NEMESTICE_MEDIUM_METEOR_CRASH_SITE_INTERVAL = 90.0

_G.NEMESTICE_LARGE_METEOR_CRASH_SITE_INITIAL_DELAY = 90.0
_G.NEMESTICE_LARGE_METEOR_CRASH_SITE_INTERVAL = 180.0

_G.NEMESTICE_METEOR_WARNING_TIME = 15.0
_G.NEMESTICE_METEOR_WARNING_TIME_FAKE_CINEMATIC_METEOR = 10.0
_G.NEMESTICE_METEOR_STATE_WAITING = 0 -- Waiting for the next fall
_G.NEMESTICE_METEOR_STATE_WARNING = 1 -- First ping
_G.NEMESTICE_METEOR_STATE_MARKING = 2 -- Second ping and marker on the ground
_G.NEMESTICE_METEOR_STATE_FALLING = 3 -- Model falling from the sky

_G.NEMESTICE_METEOR_CRASH_SITE_ENERGY_VALUE = 6 -- starting value, increases as game goes on.
_G.NEMESTICE_METEOR_MEDIUM_ENERGY_VALUE = 1 -- plus 1 per 3 "rounds"
_G.NEMESTICE_METEOR_SMALL_SHARD_CHANCE = 0 -- chance for a small meteor to drop a shard

_G.NEMESTICE_METEOR_DROP_COUNT = 10
_G.NEMESTICE_METEOR_DROP_RADIUS = 500

_G.NEMESTICE_METEOR_SIZE_SMALL = 0
_G.NEMESTICE_METEOR_SIZE_MEDIUM = 1
_G.NEMESTICE_METEOR_SIZE_LARGE = 2

_G.NEMESTICE_MEDIUM_METEORS_ENABLED = true

-- these are precached, DO NOT ADD TO nemestice_precache!
_G.NEMESTICE_METEOR_SHARD_MODELS =
{
	"models/props_gameplay/moon_shard/moon_shard_001.vmdl",
	"models/props_gameplay/moon_shard/moon_shard_002.vmdl",
	"models/props_gameplay/moon_shard/moon_shard_003.vmdl",
	"models/props_gameplay/moon_shard/moon_shard_004.vmdl",
	"models/props_gameplay/moon_shard/moon_shard_005.vmdl",
}

_G.BATTLE_POINT_DROP_FIRST_TOWER = 100
_G.BATTLE_POINT_DROP_METEOR_STUN = 50
_G.BATTLE_POINT_DROP_SHRINE_TEAMFIGHT = 75
_G.BATTLE_POINT_DROP_NEUTRAL_STEAL = 50
_G.BATTLE_POINT_DROP_FULL_CHANNEL = 125

_G.BATTLE_POINT_SHRINE_HEAL_NUM_HEROES_THRESHOLD = 2