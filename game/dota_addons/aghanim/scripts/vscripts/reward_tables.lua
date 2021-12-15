require( "constants" )

_G.USE_PRICED_REWARDS = true
_G.PRICED_ITEM_GOLD_MIN_PCT = 0.60
_G.PRICED_ITEM_GOLD_MAX_PCT = 1.20
_G.PRICED_ITEM_BONUS_DEPTH_PCT = 0.05
_G.GOLD_REWARD_CHOICE_MIN_PCT = 0.375	-- 1.5 * 0.25
_G.GOLD_REWARD_CHOICE_MAX_PCT = 0.525	-- 1.5 * 0.35
_G.ELITE_VALUE_MODIFIER = 2
_G.ARCANE_FRAGMENT_ELITE_VALUE_MODIFIER = 1.25
_G.ELITE_NEUTRAL_ITEM_VALUE_MODIFIER = 1.5

-- Amount of XP earned per hero per depth (if the encounter gives XP)
_G.ENCOUNTER_DEPTH_XP_REWARD =
{
	0,		--1 Starting Room
	900, 	--2,
	1000, 	--3, 
	1100,   --4,  
	1200,   --5, <after this, 4200 total, level 8> 
	400,    --6 Act 1 Boss <after this, 4600 total, level 9> 
	0,   	--7 Transition->Act2, Reward Room  
	1575,  	--8, <level 11, 6175>
	1775,   --9, <level 13, 7950> 
	1975,   --10, <level 14, 9925> 
	2175,   --11, <after this, 12,100 total, level 16>
	0,	    --12, 
	1900,   --13 Act 2 Boss <after this, 14010 total, level 17> 
	2700,	--14 Act 3 Reward Room
	3200,   --15
	3500,   --16, 
	6395,   --17,
	0,   	--18, <after this, level 25>
	0,   	--19 Act 3 Boss
}

-- Amount of gold earned per hero per depth (if the encounter gives gold)
_G.ENCOUNTER_DEPTH_GOLD_REWARD =
{
	0,	--1 Starting Room
	650, 	--2, 
	775, 	--3, 
	900,    --4,  
	1000,   --5,  
	1000,  	--6 Act 1 Boss README: The boss has a gold bag fountain ability that gives 1000 gold, but gets slammed to 0 at reward time
	2500,	--7 Transition->Act2  ( Note: this gold is not guaranteed )
	1250,  	--8 
	1500,   --9  
	1750,   --10  
	2000,   --11  
	   0,   --12 <empty>  
	2000,   --13 Act 2 Boss README: The boss has a gold bag fountain ability that gives 2000 gold, but gets slammed to 0 at reward time
	   0,	--14 Act 3 Reward Room [chickens drop loot]
	2300,   --15
	2500,   --16 
	2700,   --17 
	0,   	--18 <empty> 
	2800,   	--19 Act 3 Boss, gold reward is for items at Bristle only
}

_G.ENCOUNTER_DEPTH_BATTLE_POINTS =
{
	0, --1
	30, --2
	30,	--3
	30, --4
	30, --5
	60, --6  120
	0, 	--7
	30, --8
	30, --9
	30, --10
	30, --11
	0, --12
	60, --13 240
	0, --14
	30, --15
	30, --16
	30, --17
	0, --18
	60, --19 340
}

_G.BATTLE_POINT_DIFFICULTY_MODIFIERS =
{
	1,
	1.1,
	1.2,
	1.3,
	1.4
}

_G.BATTLE_POINT_MIN_DROP_VALUE = 20
_G.BATTLE_POINT_MAX_DROP_VALUE = 40

_G.ARCANE_FRAGMENT_ROOM_CLEAR_VALUE = 0.5
_G.ARCANE_FRAGMENT_DROP_VALUE = 0.5

_G.ARCANE_FRAGMENT_DROP_VALUE_VARIANCE = 0.4

_G.ENCOUNTER_DEPTH_ARCANE_FRAGMENTS =
{
	0, --1
	20, --2
	20,	--3
	20, --4
	20, --5
	40, --6  
	0, 	--7
	22, --8
	22, --9
	22, --10
	22, --11
	0, --12
	44, --13 
	0, --14
	24, --15
	24, --16
	24, --17
	0, --18
	48, --19 
}

_G.ARCANE_FRAGMENT_DIFFICULTY_MODIFIERS =
{
	1,
	1.1,
	1.2,
	1.3,
	1.4
}

_G.ARCANE_FRAGMENT_RANDOM_DROP_CHANCES =
{
	{ low_chance =  0, high_chance =  63, num_fragments = 0 },
	{ low_chance = 63, high_chance =  90, num_fragments = 1 },
	{ low_chance = 90, high_chance = 99, num_fragments = 2 },
	{ low_chance = 99, high_chance = 100, num_fragments = 5 },
}


_G.REWARD_TIER_TABLE = 
{
	REWARD_TIER_UPGRADE =
	{
		REWARD_TYPE_ABILITY_UPGRADE = 100,
	},

	REWARD_TIER_MINOR_UPGRADE =
	{
		REWARD_TYPE_MINOR_ABILITY_UPGRADE = 100,
	},

	REWARD_TIER_OTHER =
	{
		--REWARD_TYPE_GOLD = 33,
		--REWARD_TYPE_ITEM = 33,
		--REWARD_TYPE_MINOR_ABILITY_UPGRADE = 50,
		REWARD_TYPE_MINOR_STATS_UPGRADE = 100,
		--REWARD_TYPE_EXTRA_LIVES = 1,

	},
}

_G.ROOM_CHOICE_REWARDS =
{
	REWARD_TYPE_GOLD = 33,
	REWARD_TYPE_EXTRA_LIVES = 33,
	REWARD_TYPE_TREASURE = 33,
}

_G.TREASURE_REWARDS = {}
table.insert( TREASURE_REWARDS, 1, 
	{
	"item_purification_potion",
	"item_ravage_potion",
	"item_echo_slam_potion",
	"item_arcanist_potion",
	"item_book_of_strength",
	"item_book_of_agility",
	"item_book_of_intelligence",
	"item_dragon_potion",
} )

table.insert( TREASURE_REWARDS, 2, 
	{
	"item_torrent_effect_potion",
	"item_shadow_wave_effect_potion",
	"item_tome_of_greater_knowledge",
	"item_book_of_greater_strength",
	"item_book_of_greater_agility",
	"item_book_of_greater_intelligence",
	"item_aghsfort_refresher_shard",
})

_G.PRICED_ITEM_REWARD_LIST =
{
	item_broom_handle = 600,
	item_keen_optic = 600,
	item_ocean_heart = 600,
	item_oblivions_locket = 600,	
	item_precious_egg = 600,
	item_faded_broach = 600,
	item_arcane_ring = 600,

	
	item_longclaws_amulet = 750,
	item_bear_cloak = 750,
	item_winter_embrace = 750,
	item_poor_mans_shield = 750,
	
	--item_creed_of_omniscience = 750,

	item_ogre_seal_totem = 1000,
	item_dragon_scale = 1000,
	item_essence_ring = 1000,
	item_pupils_gift = 1000,
	
	item_paw_of_lucius = 1250,
	item_enchanted_quiver = 1250,
	item_ring_of_aquila = 1250,
	item_grove_bow = 1250,
	item_bogduggs_baldric = 1250,
	item_craggy_coat = 1250,
	item_pelt_of_the_old_wolf = 1250,

	item_nether_shawl = 1500,
	item_imp_claw = 1500,
	item_ambient_sorcery = 1500,
    item_vambrace = 1500,

    item_greater_faerie_fire = 1750,
	
	item_vampire_fangs = 2000,
	--item_lifestone = 2000,
	--item_ice_dragon_maw = 2000,

	item_quickening_charm = 2500,
	item_titan_sliver = 2500,
	item_sign_of_the_arachnid = 2500,
	item_phoenix_ash = 2500,

	item_preserved_skull = 3000,
	item_gravel_foot = 3000,
	item_bogduggs_cudgel = 3000,
	item_orb_of_destruction = 3000,
	item_paladin_sword = 3000,
	item_havoc_hammer = 3000,
    item_witless_shako = 3000,
    item_panic_button = 3000,
    item_minotaur_horn = 3000,

	item_stony_coat = 3250,
	item_bogduggs_lucky_femur = 3250,
	item_illusionsts_cape = 3500,
	
	item_stonework_pendant = 3750,
	item_spell_prism = 4000,
	item_timeless_relic = 4000,
	item_watchers_gaze = 4250,
	item_guardian_shell = 4250,

	
	item_ex_machina = 4500,
	item_mirror_shield = 4750,
	item_wand_of_the_brine = 4750,
	item_fallen_sky = 4750,

	item_treads_of_ermacor = 5000,
	item_demonicon = 5000,
	item_force_boots = 5500,
	item_slippers_of_the_abyss = 5500,
	item_apex = 6000,
	item_desolator_2 = 6000,
}


_G.ROOM_REWARDS =
{
	-- Act 1
	depth_1 =
	{
		normal = { { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 } }
	},
	depth_2 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_3 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_4 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_5 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},	
	depth_6 = -- Boss
	{
		normal = { { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 } }
	},
	depth_7 = -- Transition
	{
		normal = { }
	},

	-- Act 2
	depth_8 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_9 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_10 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_11 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_12 =
	{
		normal = { },
	},	
	depth_13 = -- Boss
	{
		normal = { { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 } }
	},

	-- Act 3
	depth_14 =
	{
		normal = { },
	},
	depth_15 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_16 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_17 =
	{
		normal = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
		elite  = { { REWARD_TIER_OTHER = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, { REWARD_TIER_MINOR_UPGRADE = 100 }, },
	},
	depth_18 =
	{
		normal = { },
	},	
	depth_19 = -- Boss
	{
		normal = { },	-- No need for rewards, the game is done [or should we put BP rewards in here?]
	},

	-- Traps
	traps =
	{
		normal = { { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 }, { REWARD_TIER_UPGRADE = 100 } }
	},	
}
