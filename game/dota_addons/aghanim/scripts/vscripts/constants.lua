
-- General Game Mode Config
_G.AGHANIM_PLAYERS = 4
_G.AGHANIM_THINK_INTERVAL = 0.25

_G.AGHANIM_TIMED_RESPAWN_MODE = true
_G.AGHANIM_TIMED_RESPAWN_TIME = 10.0
_G.AGHANIM_RESPAWN_VISION_RANGE = 800

_G.TWILIGHT_MAZE_VISION_RANGE = 300 -- hack

_G.AGHANIM_MAX_LIVES = 3
_G.AGHANIM_STARTING_LIVES = AGHANIM_MAX_LIVES


_G.AGHANIM_STARTING_GOLD = 300
_G.AGHANIM_STARTING_SALVES = 2
_G.AGHANIM_STARTING_MANGOES = 2
_G.AGHANIM_ENABLE_BOTTLE = true
_G.AGHANIM_ENCOUNTER_BOTTLE_CHARGES = 1

_G.AGHANIM_ASCENSION_APPRENTICE = 0
_G.AGHANIM_ASCENSION_MAGICIAN = 1
_G.AGHANIM_ASCENSION_SORCERER = 2
_G.AGHANIM_ASCENSION_GRAND_MAGUS = 3
_G.AGHANIM_ASCENSION_APEX_MAGE = 4

_G.AGHANIM_TRIAL_ASCENSION = AGHANIM_ASCENSION_GRAND_MAGUS

_G.LIFE_REVIVE_COST = 1
_G.LIFE_BUYBACK_COST = 2
_G.REVIVE_HEALTH_PCT = 100
_G.REVIVE_MANA_PCT = 100

_G.GOLD_BAG_DROP_PCT = 33
_G.HEALTH_POTION_DROP_PCT = 2
_G.MANA_POTION_DROP_PCT = 2
_G.HEAL_ON_ENCOUNTER_COMPLETE = true

_G.NUM_VIABLE_ROOMS_FOR_DROPPED_ITEMS = 11
_G.PCT_BASE_NEUTRAL_ITEM_DROP = 12
_G.PCT_BASE_TWO_ITEM_DROP = 0
_G.NUM_NEUTRAL_ITEMS_DROPPED = 0
_G.NUM_NEUTRAL_ITEMS_ROOM_REWARD = 2
_G.NUM_NEUTRAL_ITEMS_ROOM_REWARD_ELITE = 3

_G.CONSUMABLES_IN_ANY_ROOM_REWARD = true
_G.NUM_CONSUMABLES_FROM_ROOM_REWARD = 1
_G.PCT_CONSUMABLE_ENEMY_ROOM_CHANCE = 50

_G.NUM_LIVES_FROM_BOSSES = 0

_G.MELEE_BLOCK_SCALING_VALUE = 2

-- Audio
_G.VOICE_LAUGH_COOLDOWN = 20.0
_G.VOICE_PERIODIC_TAUNT_COOLDOWN = 35.0
_G.VOICE_LINE_COOLDOWN = 4.0
_G.VOICE_VOLUME = 1.4

-- Atlas 
_G.FREE_EVENT_ROOMS = true
_G.ALWAYS_SPAWN_ROSHAN_BEFORE_BOSS = true

_G.ROOM_TYPE_INVALID = 0
_G.ROOM_TYPE_STARTING = 1
_G.ROOM_TYPE_ENEMY = 2
_G.ROOM_TYPE_TRAPS = 3
_G.ROOM_TYPE_BOSS = 4
_G.ROOM_TYPE_TRANSITIONAL = 5
_G.ROOM_TYPE_BONUS = 6
_G.ROOM_TYPE_EVENT = 7

_G.RoomTypeStrings = {}

RoomTypeStrings[ ROOM_TYPE_ENEMY ]= "ROOM_TYPE_ENEMY"
RoomTypeStrings[ ROOM_TYPE_BOSS ] = "ROOM_TYPE_BOSS"
RoomTypeStrings[ ROOM_TYPE_STARTING ] = "ROOM_TYPE_STARTING"
RoomTypeStrings[ ROOM_TYPE_TRAPS ] = "ROOM_TYPE_TRAPS"
RoomTypeStrings[ ROOM_TYPE_TRANSITIONAL ] = "ROOM_TYPE_TRANSITIONAL"
RoomTypeStrings[ ROOM_TYPE_BONUS ] = "ROOM_TYPE_BONUS"
RoomTypeStrings[ ROOM_TYPE_EVENT ] = "ROOM_TYPE_EVENT"


function GetStringForRoomType( nType )
	return _G.RoomTypeStrings[ nType ]
end

-- Room Exit directions
_G.ROOM_EXIT_LEFT = 0
_G.ROOM_EXIT_TOP = 1
_G.ROOM_EXIT_RIGHT = 2

-- these are only used for UI purposes.
_G.ROOM_EXIT_BOTTOM = 3 
_G.ROOM_EXIT_INVALID = -1

function GetEntranceDirectionForExitType( nExitDirection )
	if nExitDirection == ROOM_EXIT_LEFT then
		return ROOM_EXIT_RIGHT
	end
	if nExitDirection == ROOM_EXIT_TOP then
		return ROOM_EXIT_BOTTOM
	end
	if nExitDirection == ROOM_EXIT_RIGHT then
		return ROOM_EXIT_LEFT
	end

	-- You can never exit from the bottom
	return ROOM_EXIT_INVALID
end

-- Amount of XP earned per hero per depth (if the encounter gives XP)

-- setting this to a value greater than zero will level up every creature; increasing its max hp and attack damage
-- a value of 1.0 will increase HP by 30%, and damage by 10%; other values scale accordingly
_G.GAME_DIFFICULTY_FACTOR = 0

_G.DEFAULT_PORTAL_SPAWN_INTERVAL = 30
_G.PORTAL_ESCALATION_ENABLED = true
_G.PORTAL_ESCALATION_RATE = 2.5

_G.PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE = 1
_G.PORTAL_TRIGGER_TYPE_TIME_RELATIVE = 2
_G.PORTAL_TRIGGER_TYPE_KILL_PERCENT = 3
_G.PORTAL_TRIGGER_TYPE_HEALTH_PERCENT = 4

_G.DEFAULT_MIN_CRATES_ENEMY_ENC = 8
_G.DEFAULT_MAX_CRATES_ENEMY_ENC = 10

_G.DEFAULT_MIN_CRATES_BOSS_ENC = 12
_G.DEFAULT_MAX_CRATES_BOSS_ENC = 15

_G.DEFAULT_MIN_CHESTS = 1
_G.DEFAULT_MAX_CHESTS = 2

_G.ENCOUNTER_SPAWN_BARRELS_CHANCE = 40
_G.DEFAULT_MIN_BARRELS_ENEMY_ENC = 3
_G.DEFAULT_MAX_BARRELS_ENEMY_ENC = 6

_G.AGHANIM_REWARD_RARITY_COMMON = 0
_G.AGHANIM_REWARD_RARITY_ELITE = 1
_G.AGHANIM_REWARD_RARITY_LEGENDARY = 2

_G.BLOODSTONE_GAINABLE_CHARGES_PER_ROOM = 2

-- blessing constants
_G.BLESSING_TYPE_MODIFIER = 1
_G.BLESSING_TYPE_ITEM_GRANT = 2
_G.BLESSING_TYPE_LIFE_GRANT = 3
_G.BLESSING_TYPE_GOLD_GRANT = 4

_G.TIME_BEFORE_DETECT_INVIS = 300
_G.TIME_BEFORE_PROVIDE_VISION = 300

_G.POSITIVE_BUFFS_TO_PURGE_AT_ROOM_CLEAR =
{
	"modifier_aghsfort_undying_decay_buff",
	"modifier_aghsfort_undying_soul_rip_share_strength",
	"modifier_aghsfort_undying_flesh_golem",
	"modifier_aghsfort_undying_tombstone_zombie_aura",
	"modifier_aghsfort_special_undying_consume_zombies_buff",

	"modifier_aghsfort_dragon_potion",

	"modifier_aghsfort_kunkka_ghost_ship_damage_absorb",
	"modifier_aghsfort_kunkka_ghost_ship_damage_delay",
	"modifier_aghsfort_kunkka_x_marks_the_spot",

	"modifier_aghsfort_arc_warden_boss_spark_wraith_missile_target",
}

_G.UNITS_TO_DESTROY_AT_ROOM_CLEAR = 
{
	"npc_aghsfort_unit_tombstone1",
	"npc_aghsfort_unit_tombstone2",
	"npc_aghsfort_unit_tombstone3",
	"npc_aghsfort_unit_tombstone4",
	"npc_aghsfort_juggernaut_healing_ward",
	"npc_aghsfort_juggernaut_blade_fury_npc",
}

_G.ANNOUNCER_HOLD_ENCOURAGE_LINE_BASE = 40.0
_G.ANNOUNCER_HOLD_ENCOURAGE_LINE_DAMAGE = 15.0
_G.ANNOUNCER_ENCOURAGE_LINE_COOLDOWN = 30.0

_G.HERO_GENDER = 
{
	npc_dota_hero_omniknight = 1,
	npc_dota_hero_magnataur = 1,
	npc_dota_hero_phantom_assassin = 0,
	npc_dota_hero_winter_wyvern = 0,
	npc_dota_hero_disruptor = 1,
	npc_dota_hero_snapfire = 0,
	npc_dota_hero_tusk = 1,
	npc_dota_hero_ursa = 1,
	npc_dota_hero_sniper = 1,
	npc_dota_hero_mars = 1,
	npc_dota_hero_viper = 1,
	npc_dota_hero_weaver = 1,
	npc_dota_hero_witch_doctor = 1,
	npc_dota_hero_queenofpain = 0,
	npc_dota_hero_templar_assassin = 0,
	npc_dota_hero_slark = 1,
	npc_dota_hero_lina = 0,
	npc_dota_hero_juggernaut = 1,
	npc_dota_hero_drow_ranger = 0,
	npc_dota_hero_luna = 0,
	npc_dota_hero_lich = 1,
	npc_dota_hero_kunkka = 1,
	npc_dota_hero_undying = 1,
	npc_dota_hero_void_spirit = 1,
	npc_dota_hero_gyrocopter = 1,
	npc_dota_hero_dawnbreaker = 0,
	npc_dota_hero_bane = 1,
	npc_dota_hero_phoenix = 1,
	npc_dota_hero_sand_king = 1,
	npc_dota_hero_clinkz = 1
}
