
--------------------------------------------------------------------------------
-- Game end states
--------------------------------------------------------------------------------

_G.NOT_ENDED = 0
_G.VICTORIOUS = 1
_G.DEFEATED = 2


--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

_G.HERO_NIGHTTIME_VISION_RANGE = 1800

_G.DOTA_MAX_ABILITIES = 30

_G.ABILITY_NOT_LEARNABLE = 4

_G.KILLING_SPREE_KILLS = 100
_G.DOMINATING_KILLS = 200
_G.MEGA_KILL_KILLS = 300
_G.UNSTOPPABLE_KILLS = 400
_G.WICKED_SICK_KILLS = 500
_G.MONSTER_KILL_KILLS = 600
_G.GODLIKE_KILLS = 700
_G.BEYOND_GODLIKE_KILLS = 800

_G.ULTRA_KILL_KILLS = 25
_G.RAMPAGE_KILLS = 50

_G.SPEECH_COOLDOWN = 3.0

--------------------------------------------------------------------------------

-- Leveling/gold data for console command "holdout_test_round"
_G.XP_PER_LEVEL_TABLE = {
	0,-- 1
	200,-- 2
	500,-- 3
	900,-- 4
	1400,-- 5
	2000,-- 6
	2640,-- 7
	3300,-- 8
	3980,-- 9
	4680,-- 10
	5400,-- 11
	6140,-- 12
	7340,-- 13
	8565,-- 14
	9815,-- 15
	11090,-- 16
	12390,-- 17
	13715,-- 18
	15115,-- 19
	16605,-- 20
	18205,-- 21
	20105,-- 22
	22305,-- 23
	24805,-- 24
	27500 -- 25
}

--------------------------------------------------------------------------------

_G.STARTING_GOLD = 625
_G.ROUND_EXPECTED_VALUES_TABLE = 
{
	{ gold = STARTING_GOLD, xp = 0 }, -- 1
	{ gold = 1054+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[4] }, -- 2
	{ gold = 2212+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[6] }, -- 3
	{ gold = 3456+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[8] }, -- 4
	{ gold = 4804+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[11] }, -- 5
	{ gold = 6256+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[11] }, -- 6
	{ gold = 7812+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[13] }, -- 7
	{ gold = 9471+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[14] }, -- 8
	{ gold = 11234+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[16] }, -- 9
	{ gold = 13100+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[18] }, -- 10
	{ gold = 15071+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[18] }, -- 11
	{ gold = 17145+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[19] }, -- 12
	{ gold = 19322+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[21] }, -- 13
	{ gold = 21604+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[22] }, -- 14
	{ gold = 23368+STARTING_GOLD, xp = XP_PER_LEVEL_TABLE[24] } -- 15
}

_G.WINTER_MAP_ENEMY_SAFE_UPPER_LEFT = Vector( 33, 3100, 256 )
_G.WINTER_MAP_CENTER_RUNE = Vector( 2382, 20, 32 )

_G.HERDING_PENGUIN_ROUND_DURATION = 40 -- this needs to be in sync with winter.txt

_G.MAX_GIFT_DROPS_PER_ROUND = 1
_G.GIFT_LAST_CREATURE_BASE_DROP_PCT_CHANCE = 10
_G.GIFT_DROP_PCT_CHANCE_INCREASE_PER_ROUND = 0.5
_G.GIFT_DROP_CHANCE_PER_CREATURE = 0.25

_G.GIFT_ASSOCIATED_CONSUMABLES = {}
_G.GIFT_ASSOCIATED_CONSUMABLES[ "item_throw_snowball" ] = 17465
_G.GIFT_ASSOCIATED_CONSUMABLES[ "item_summon_snowman" ] = 17472
_G.GIFT_ASSOCIATED_CONSUMABLES[ "item_decorate_tree" ] = 17471
_G.GIFT_ASSOCIATED_CONSUMABLES[ "item_festive_firework" ] = 17473

_G.TOWER_ARMOR = 20
_G.SHRINE_ARMOR = 17

_G.GAME_DIFFICULTY_FACTOR = 0

--------------------------------------------------------------------------------
