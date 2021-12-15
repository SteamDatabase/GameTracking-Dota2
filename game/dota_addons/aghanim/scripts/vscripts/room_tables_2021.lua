require( "constants" )

_G.MAP_ATLAS_HUB_ORIGIN = Vector( -8192, -12288, 0 )
_G.MAP_ATLAS_HUB_DIMENSION = 8192
_G.MAP_ATLAS_EVENT_ROOM_SIZE = 3072
_G.MAP_ATLAS_ROOM_DIMENSION = 5120
_G.MAP_ATLAS_BOSS_ROOM_DIMENSION = 6144
_G.MAP_ATLAS_MIN_BONUS_ROOM_DIMENSION = 5120
_G.MAP_ATLAS_MAX_BONUS_ROOM_DIMENSION = 16384
_G.MAP_ATLAS_ELITE_ROOMS_PER_ACT =
{
	-- NOTE: Indexed by ascension level
	{
		0, 1, 2
	},
	{
		1, 1, 2
	},
	{
		2, 2, 3
	},	
	{
		3, 3, 4
	},	
	{
		4, 4, 4
	},	
}


_G.MAP_TRAP_ROOMS_PER_ACT =
{
	1, 1, 1
}

_G.MAP_BONUS_TRAP_ROOMS_LATER_ASCENSIONS_PCT = 25
_G.MAP_BONUS_TRAP_ROOMS_LATER_ACTS_PCT = 25

_G.MAP_HIDDEN_ENCOUNTERS_PER_ACT =
{
	1, 2, 1
}
_G.MAP_EVENT_ROOMS_PER_ACT =
{
	1, 1, 1,	
}

_G.MAP_ATLAS =
{
	--
	-- Act 1
	--

	hub =
	{
		name = "hub",
		exit = "a1_1",
		exit_direction = ROOM_EXIT_LEFT,
		nRoomType = ROOM_TYPE_STARTING,
		bCannotBeElite = true,
		nDepth = 1,
		szTemplateMap = "aghs2_encounters/hub",
		vCenter = MAP_ATLAS_HUB_ORIGIN,
		vSize = Vector( 6144, MAP_ATLAS_HUB_DIMENSION, 0 ),
		szMinimapMapName = "hub",
		nMinimapScale = 4.5,
		nExitChoices = 2,
		encounters = 
		{
			"encounter_hub",
		},

	},

	a1_1 =
	{
		name = "a1_1",
		exit = "a1_2",
		nRoomType = ROOM_TYPE_ENEMY,
		bCannotBeTrap = true,
		nDepth = 2,
		szTemplateMap = "aghs2_encounters/template_maps/a1_1_125_square_template",
		vCenter = Vector( -13824, -10752, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_bears_lair",
			"encounter_wendigoes",
			"encounter_collapsed_mines",
			
			--Legacy
			"encounter_pine_grove",
		},
	},

	a1_1_event =
	{
		name = "a1_1_event",
		exit = "a1_2",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 2,
		szTemplateMap = "aghs2_encounters/template_maps/a1_1_125_square_event_template",
		vCenter = Vector( -14848, -6912, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		bForceEvent = false,
		encounters =
		{
			"encounter_event_slark",
			"encounter_event_tinker_range_retrofit",
			"encounter_event_zeus",
			"encounter_event_naga_bottle_rune",
			"encounter_event_leshrac",
		},
	},

	a1_2 =
	{
		name = "a1_2",
		exit = "a1_3",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 3,
		szTemplateMap = "aghs2_encounters/template_maps/a1_2_125_square_template",
		vCenter = Vector( -11008, -5632, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_dark_forest",
			"encounter_tropical_keep",
			"encounter_salty_shore",

			--Traps
			"encounter_regal_traps",
			"encounter_deep_traps",
			
			--Legacy
			"encounter_sacred_grounds",
		},
	},

	a1_2_event =
	{
		name = "a1_2_event",
		exit = "a1_3",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 3,
		szTemplateMap = "aghs2_encounters/template_maps/a1_2_125_square_event_template",
		vCenter = Vector( -12032, -1792, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_ogre_magi_casino",
			"encounter_event_slark",
			"encounter_event_warlock_library",
			"encounter_event_brewmaster_bar",
			"encounter_event_tinker_range_retrofit",
			"encounter_event_zeus",
			"encounter_event_leshrac",
		},
	},

	a1_3 =
	{
		name = "a1_3",
		exit = "a1_4",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 4,
		szTemplateMap = "aghs2_encounters/template_maps/a1_3_125_square_template",
		vCenter = Vector( -8192, -512, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_blob_dungeon",
			"encounter_multiplicity",
			"encounter_mole_cave",
			
			--Traps
			"encounter_prison_traps",
			"encounter_bridge_traps",

			--Legacy
			"encounter_desert_oasis",
		},
	},

	a1_3_event =
	{
		name = "a1_3_event",
		exit = "a1_4",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 4,
		szTemplateMap = "aghs2_encounters/template_maps/a1_3_125_square_event_template",
		vCenter = Vector( -6912, 3328, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_ogre_magi_casino",
			"encounter_event_slark",
			"encounter_event_naga_bottle_rune",
			"encounter_event_warlock_library",
			"encounter_event_brewmaster_bar",
			"encounter_event_tinker_range_retrofit",
			"encounter_event_zeus",
		},
	},

	a1_4 =
	{
		name = "a1_4",
		exit = "a1_5_boss",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 5,
		szTemplateMap = "aghs2_encounters/template_maps/a1_4_125_square_template",
		vCenter = Vector( -11008, 4608, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 1,
		encounters =
		{	
			"encounter_swamp_of_sadness",
			"encounter_aziyog_caverns",
			"encounter_bamboo_garden",

			-- Traps
			"encounter_bog_traps",
			"encounter_cavern_traps",

			-- Legacy
			"encounter_catacombs",
		},
	},

	a1_4_event =
	{
		name = "a1_4_event",
		exit = "a1_5_boss",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 5,
		szTemplateMap = "aghs2_encounters/template_maps/a1_4_125_square_event_template",
		vCenter = Vector( -14848, 6912, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 1,
		bForceEvent = false,
		encounters =
		{
			"encounter_event_ogre_magi_casino",
			"encounter_event_slark",
			"encounter_event_naga_bottle_rune",
			"encounter_event_warlock_library",
			"encounter_event_brewmaster_bar",
			"encounter_event_tinker_range_retrofit",
			"encounter_event_zeus",
		},
	},

	a1_5_boss =
	{
		name = "a1_5_boss",
		exit = "a1_6_bonus",
		nRoomType = ROOM_TYPE_BOSS,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 6,
		szTemplateMap = "aghs2_encounters/template_maps/a1_5_125_square_boss_template",
		vCenter = Vector( -10496, 10240, 0 ),
		vSize = Vector( MAP_ATLAS_BOSS_ROOM_DIMENSION, MAP_ATLAS_BOSS_ROOM_DIMENSION, 0 ),
		nMinimapScale = 5,
		nExitChoices = 1,
		encounters =
		{
			"encounter_boss_dark_willow",
			"encounter_boss_winter_wyvern",
			"encounter_boss_earthshaker",
			"encounter_boss_rizzrick",
		},
	},

	a1_6_bonus =
	{
		name = "a1_6_bonus",
		exit = "hub",
		nRoomType = ROOM_TYPE_BONUS,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 7,
		szTemplateMap = "aghs2_encounters/template_maps/a1_6_125_square_bonus_template",
		vCenter = Vector( 768, 13824, 0 ),
		vSize = Vector( MAP_ATLAS_MAX_BONUS_ROOM_DIMENSION, MAP_ATLAS_MIN_BONUS_ROOM_DIMENSION, 0 ),
		nMinimapScale = 2,
		nExitChoices = 1,
		encounters =
		{
			"encounter_bonus_mango_orchard",
			"encounter_bonus_hooking",

			--Legacy
			"encounter_penguin_sledding"
		},
	},

	--
	-- Act 2
	--

	a2_1 =
	{
		name = "a2_1",
		exit = "a2_2",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 8,
		szTemplateMap = "aghs2_encounters/template_maps/a2_1_125_square_template",
		vCenter = Vector( -5376, -5632, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_gaolers",
			"encounter_spook_town",
			"encounter_eggs_holdout",

			--Traps
			"encounter_temple_traps",
			"encounter_canopy_traps",

			--Legacy
			"encounter_mushroom_mines2021",
		},
	},

	a2_1_event =
	{
		name = "a2_1_event",
		exit = "a2_2",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 8,
		szTemplateMap = "aghs2_encounters/template_maps/a2_1_125_square_event_template",
		vCenter = Vector( -1280, -6912, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_ogre_magi_casino",
			"encounter_event_naga_bottle_rune",
			"encounter_event_small_tiny_shrink",
			"encounter_event_big_tiny_grow",
			"encounter_event_leshrac",
		},
	},

	a2_2 =
	{
		name = "a2_2",
		exit = "a2_3",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 9,
		szTemplateMap = "aghs2_encounters/template_maps/a2_2_125_square_template",
		vCenter = Vector( -256, -2816, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_outworld",
			"encounter_leshrac",
			"encounter_twilight_maze",

			--Traps
			"encounter_ruinous_traps",
			"encounter_beach_traps",

			--Legacy
			"encounter_inner_ring",
		},
	},

	a2_2_event =
	{
		name = "a2_2_event",
		exit = "a2_3",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 9,
		szTemplateMap = "aghs2_encounters/template_maps/a2_2_125_square_event_template",
		vCenter = Vector( -4096, -1792, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_ogre_magi_casino",
			"encounter_event_doom_life_swap",
			"encounter_event_small_tiny_shrink",
			"encounter_event_big_tiny_grow",
			"encounter_event_leshrac",
		},
	},

	a2_3 =
	{
		name = "a2_3",
		exit = "a2_4",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 10,
		szTemplateMap = "aghs2_encounters/template_maps/a2_3_125_square_template",
		vCenter = Vector( -3072, 2304, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_snapfire",
			"encounter_stonehall_citadel",
			"encounter_polarity_swap",

			--Traps
			"encounter_mystical_traps",
			"encounter_hedge_traps",
			
			--Legacy
			"encounter_golem_gorge",
		},
	},

	a2_3_event =
	{
		name = "a2_3_event",
		exit = "a2_4",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 10,
		szTemplateMap = "aghs2_encounters/template_maps/a2_3_125_square_event_template",
		vCenter = Vector( -1792, 6144, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_naga_bottle_rune",
			"encounter_event_doom_life_swap",
			"encounter_event_small_tiny_shrink",
			"encounter_event_big_tiny_grow",
			"encounter_event_leshrac",
		},
	},

	a2_4 =
	{
		name = "a2_4",
		exit = "a2_5_boss",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 11,
		szTemplateMap = "aghs2_encounters/template_maps/a2_4_125_square_template",
		vCenter = Vector( 2048, 5120, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 1,
		encounters =
		{
			"encounter_forbidden_palace",
			"encounter_crypt_gate",
			"encounter_pugna_nether_reaches",

			--Traps
			"encounter_mining_traps",
			"encounter_dungeon_traps",

			--Legacy
			"encounter_temple_siege",
		},
	},

	a2_4_event =
	{
		name = "a2_4_event",
		exit = "a2_5_boss",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 11,
		szTemplateMap = "aghs2_encounters/template_maps/a2_4_125_square_event_template",
		vCenter = Vector( 3328, 8960, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 1,
		bForceEvent = false,
		encounters =
		{
			"encounter_event_naga_bottle_rune",	
			"encounter_event_small_tiny_shrink",
			"encounter_event_big_tiny_grow",
			"encounter_event_leshrac",
		},
	},

	a2_5_boss =
	{
		name = "a2_5_boss",
		exit = "a2_6_bonus",
		nRoomType = ROOM_TYPE_BOSS,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 12,
		szTemplateMap = "aghs2_encounters/template_maps/a2_5_125_square_boss_template",
		vCenter = Vector( 7680, 6144, 0 ),
		vSize = Vector( MAP_ATLAS_BOSS_ROOM_DIMENSION, MAP_ATLAS_BOSS_ROOM_DIMENSION, 0 ),
		nMinimapScale = 5,
		nExitChoices = 1,
		encounters =
		{
			"encounter_boss_arc_warden",
			"encounter_boss_clockwerk_tinker",
			"encounter_boss_amoeba",
			"encounter_boss_storegga",
		},
	},

	a2_6_bonus =
	{
		name = "a2_6_bonus",
		exit = "hub",
		nRoomType = ROOM_TYPE_BONUS,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 13,
		szTemplateMap = "aghs2_encounters/template_maps/a2_6_125_square_bonus_template",
		vCenter = Vector( 13312, 8192, 0 ),
		vSize = Vector( MAP_ATLAS_MIN_BONUS_ROOM_DIMENSION, MAP_ATLAS_MAX_BONUS_ROOM_DIMENSION, 0 ),
		nMinimapScale = 2,
		nExitChoices = 1,
		encounters =
		{
			--"encounter_bonus_livestock",
			"encounter_bonus_gallery",
			"encounter_bonus_smash_chickens",

			--Legacy

		},
	},

	--
	-- Act 3
	--

	a3_1 =
	{
		name = "a3_1",
		exit = "a3_2",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 14,
		szTemplateMap = "aghs2_encounters/template_maps/a3_1_125_square_template",
		vCenter = Vector( -2560, -13824, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_hidden_colosseum",
			--"encounter_frozen_ravine",

			--Traps
			"encounter_palace_traps",

			--Legacy
			"encounter_toxic_terrace", -- would be nice to replace these Alchs with another legacy

			--"encounter_bloodbound", -- REMOVED
		},
	},

	a3_1_event =
	{
		name = "a3_1_event",
		exit = "a3_2",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 14,
		szTemplateMap = "aghs2_encounters/template_maps/a3_1_125_square_event_template",
		vCenter = Vector( -1280, -9984, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_naga_bottle_rune",
			"encounter_event_alchemist_neutral_items",
			"encounter_event_morphling_attribute_shift",
			"encounter_event_doom_life_swap",
			"encounter_event_necrophos",
		},
	},

	a3_2 =
	{
		name = "a3_2",
		exit = "a3_3",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 15,
		szTemplateMap = "aghs2_encounters/template_maps/a3_2_125_square_template",
		vCenter = Vector( 2560, -12288, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 2,
		encounters =
		{
			"encounter_thunder_mountain",
			"encounter_demonic_woods",
			"encounter_frigid_pinnacle",

			--Traps
			"encounter_village_traps",

			--Legacy
			"encounter_icy_pools",
		},
	},

	a3_2_event =
	{
		name = "a3_2_event",
		exit = "a3_3",
		nRoomType = ROOM_TYPE_EVENT,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 15,
		szTemplateMap = "aghs2_encounters/template_maps/a3_2_125_square_event_template",
		vCenter = Vector( 6656, -14848, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nMinimapScale = 12,
		nExitChoices = 2,
		encounters =
		{
			"encounter_event_naga_bottle_rune",
			"encounter_event_alchemist_neutral_items",
			"encounter_event_morphling_attribute_shift",
			"encounter_event_doom_life_swap",
			"encounter_event_necrophos",
		},
	},

	a3_3 =
	{
		name = "a3_3",
		exit = "a3_4_transition",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 16,
		szTemplateMap = "aghs2_encounters/template_maps/a3_3_125_square_template",
		vCenter = Vector( 7680, -10752, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_DIMENSION, MAP_ATLAS_ROOM_DIMENSION, 0 ),
		nExitChoices = 1,
		encounters =
		{
			"encounter_forsaken_pit",
			"encounter_smashy_and_bashy",
			"encounter_push_pull",

			--Traps
			"encounter_jungle_traps",

			--Legacy
			"encounter_burning_mesa",	
		},
	},

	a3_4_transition =
	{
		name = "a3_4_transition",
		exit = "a3_4_boss",
		nRoomType = ROOM_TYPE_TRANSITIONAL,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 17,
		szTemplateMap = "aghs2_encounters/template_maps/a3_4_transition_template",
		vCenter = Vector( 7168, -6656, 0 ),
		vSize = Vector( MAP_ATLAS_EVENT_ROOM_SIZE * 1.5, MAP_ATLAS_EVENT_ROOM_SIZE, 0 ),
		nExitChoices = 1,
		nMinimapScale = 8,
		bForceEvent = false,
		encounters =
		{
			"encounter_transition_gateway",
		}	
	},


	a3_4_boss =
	{
		name = "a3_4_boss",
		exit = "a3_4_boss",
		nRoomType = ROOM_TYPE_BOSS,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 18,
		szTemplateMap = "aghs2_encounters/template_maps/a3_4_125_square_boss_template",
		vCenter = Vector( 6912, -1024, 0 ),
		vSize = Vector( MAP_ATLAS_HUB_DIMENSION, MAP_ATLAS_HUB_DIMENSION, 0 ),
		nMinimapScale = 4,
		nExitChoices = 1,
		encounters =
		{
			"encounter_primal_beast",
		},
	},

}

_G.ENCOUNTER_DEFINITIONS =
{
	-- Spawn room encounter
	encounter_hub =
	{
		nEncounterType = ROOM_TYPE_STARTING,
	},


	-- Act 1 --
	-- Depth 1 --
	encounter_wendigoes =
	{
		szMapNames = { "aghs2_encounters/a1_1_snowy_hills", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_collapsed_mines =
	{
		szMapNames = { "aghs2_encounters/a1_1_collapsed_mines", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_bears_lair = 
	{
		szMapNames = { "aghs2_encounters/a1_1_bears_lair", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_pine_grove =
	{
		szMapNames = { "aghs2_encounters/a1_1_pine_grove", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	-- Depth 2 --

	encounter_sacred_grounds =
	{
		szMapNames = { "aghs2_encounters/a1_2_sacred_grounds", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_deep_traps =
	{
		szMapNames = { "aghs2_encounters/a1_2_deep_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_dark_forest =
	{
		szMapNames = { "aghs2_encounters/a1_2_dark_forest", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_tropical_keep =
	{
		szMapNames = { "aghs2_encounters/a1_2_tropical_keep", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_salty_shore =
	{
		szMapNames = { "aghs2_encounters/a1_2_salty_shore", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_regal_traps =
	{
		szMapNames = { "aghs2_encounters/a1_2_regal_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 3 --

	encounter_desert_oasis =
	{
		szMapNames = { "aghs2_encounters/a1_3_desert_oasis", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_prison_traps =
	{
		szMapNames = { "aghs2_encounters/a1_3_prison_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_bridge_traps =
	{
		szMapNames = { "aghs2_encounters/a1_3_bridge_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_mole_cave =
	{
		szMapNames = { "aghs2_encounters/a1_3_mole_cave", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_blob_dungeon =
	{
		szMapNames = { "aghs2_encounters/a1_3_blob_dungeon", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_multiplicity =
	{
		szMapNames = { "aghs2_encounters/a1_3_multiplicity", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	-- Depth 4 --

	encounter_catacombs =
	{
		szMapNames = { "aghs2_encounters/a1_4_catacombs", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_swamp_of_sadness =
	{
		szMapNames = { "aghs2_encounters/a1_4_swamp_of_sadness", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_cavern_traps =
	{
		szMapNames = { "aghs2_encounters/a1_4_cavern_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_aziyog_caverns =
	{
		szMapNames = { "aghs2_encounters/a1_4_aziyog_caverns", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_bamboo_garden =
	{
		szMapNames = { "aghs2_encounters/a1_4_bamboo_garden", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_bog_traps =
	{
		szMapNames = { "aghs2_encounters/a1_4_bog_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},


	-- Depth 5 --

	encounter_boss_winter_wyvern =
	{
		szMapNames = { "aghs2_encounters/a1_5_ice_dragon_aerie", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	encounter_boss_earthshaker =
	{
		szMapNames = { "aghs2_encounters/a1_5_earthshaker", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	encounter_boss_dark_willow =
	{
		szMapNames = { "aghs2_encounters/a1_5_enchanted_woods", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	encounter_boss_rizzrick =
	{
		szMapNames = { "aghs2_encounters/a1_5_timbersaw", },
		nEncounterType = ROOM_TYPE_BOSS,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	-- Depth 6 --

	encounter_penguin_sledding =
	{
		szMapNames = { "aghs2_encounters/a1_6_penguin_sledding", },
		nEncounterType = ROOM_TYPE_BONUS,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_bonus_mango_orchard =
	{
		szMapNames = { "aghs2_encounters/a1_6_mango_orchard", },
		nEncounterType = ROOM_TYPE_BONUS,
	},

	encounter_bonus_hooking = 
	{
		szMapNames = { "aghs2_encounters/a1_6_bonus_hooking", },
		nEncounterType = ROOM_TYPE_BONUS,
	},

	-- Depth 7 --

	encounter_mushroom_mines2021 =
	{
		szMapNames = { "aghs2_encounters/a2_1_mushroom_mines", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_gaolers =
	{
		szMapNames = { "aghs2_encounters/a2_1_marine_prison", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_eggs_holdout =
	{
		szMapNames = { "aghs2_encounters/a2_1_eggs_holdout", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_spook_town =
	{
		szMapNames = { "aghs2_encounters/a2_1_spook_town", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_temple_traps =
	{
		szMapNames = { "aghs2_encounters/a2_1_temple_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_canopy_traps =
	{
		szMapNames = { "aghs2_encounters/a2_1_canopy_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 8 --

	encounter_inner_ring =
	{
		szMapNames = { "aghs2_encounters/a2_2_inner_ring", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_leshrac =
	{
		szMapNames = { "aghs2_encounters/a2_2_crystal_forest", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_outworld =
	{
		szMapNames = { "aghs2_encounters/a2_2_outer_rim_chasm", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_twilight_maze =
	{
		szMapNames = { "aghs2_encounters/a2_2_twilight_maze", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_ruinous_traps =
	{
		szMapNames = { "aghs2_encounters/a2_2_ruinous_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_beach_traps =
	{
		szMapNames = { "aghs2_encounters/a2_2_beach_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 9 --

	encounter_golem_gorge =
	{
		szMapNames = { "aghs2_encounters/a2_3_golem_gorge", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_snapfire =
	{
		szMapNames = { "aghs2_encounters/a2_3_canyon_pass", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_polarity_swap =
	{
		szMapNames = { "aghs2_encounters/a2_3_polarity", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_stonehall_citadel =
	{
		szMapNames = { "aghs2_encounters/a2_3_stonehall_citadel", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_mystical_traps =
	{
		szMapNames = { "aghs2_encounters/a2_3_mystical_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_hedge_traps =
	{
		szMapNames = { "aghs2_encounters/a2_3_hedge_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 10 --

	encounter_temple_siege =
	{
		szMapNames = { "aghs2_encounters/a2_4_temple_siege", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_forbidden_palace =
	{
		szMapNames = { "aghs2_encounters/a2_4_forbidden_palace", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_crypt_gate =
	{
		szMapNames = { "aghs2_encounters/a2_4_crypt_gate", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_pugna_nether_reaches =
	{
		szMapNames = { "aghs2_encounters/a2_4_pugna_nether_reaches", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},
	

	encounter_mining_traps =
	{
		szMapNames = { "aghs2_encounters/a2_4_mining_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	encounter_dungeon_traps =
	{
		szMapNames = { "aghs2_encounters/a2_4_dungeon_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 11 --

	encounter_boss_arc_warden =
	{
		szMapNames = { "aghs2_encounters/a2_5_arc_warden", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	encounter_boss_clockwerk_tinker =
	{
		szMapNames = { "aghs2_encounters/a2_5_clockwerk_and_tinker", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	encounter_boss_amoeba =
	{
		szMapNames = { "aghs2_encounters/a2_5_amoeba", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	encounter_boss_storegga =
	{
		szMapNames = { "aghs2_encounters/a2_5_storegga", },
		nEncounterType = ROOM_TYPE_BOSS,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	-- Depth 12 --

	encounter_bonus_livestock =
	{
		szMapNames = { "aghs2_encounters/a2_6_bonus_livestock", },
		nEncounterType = ROOM_TYPE_BONUS,
	},

	encounter_bonus_smash_chickens =
	{
		szMapNames = { "aghs2_encounters/a2_6_bonus_chicken_smashing", },
		nEncounterType = ROOM_TYPE_BONUS,
	},

	encounter_bonus_gallery =
	{
		szMapNames = { "aghs2_encounters/a2_6_bonus_gallery", },
		nEncounterType = ROOM_TYPE_BONUS,
	},

	-- Depth 13 --

	encounter_toxic_terrace =
	{
		szMapNames = { "aghs2_encounters/a3_1_toxic_terrace", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_hidden_colosseum =
	{
		szMapNames = { "aghs2_encounters/a3_1_hidden_colosseum", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_frozen_ravine =
	{
		szMapNames = { "aghs2_encounters/a3_1_frozen_ravine", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_palace_traps =
	{
		szMapNames = { "aghs2_encounters/a3_1_palace_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 14 --

	encounter_icy_pools =
	{
		szMapNames = { "aghs2_encounters/a3_2_icy_pools", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},
	
	encounter_demonic_woods =
	{
		szMapNames = { "aghs2_encounters/a3_2_demonic_woods", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_thunder_mountain =
	{
		szMapNames = { "aghs2_encounters/a3_2_thunder_mountain", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},
	
	encounter_frigid_pinnacle =
	{
		szMapNames = { "aghs2_encounters/a3_2_frigid_pinnacle", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_village_traps =
	{
		szMapNames = { "aghs2_encounters/a3_2_village_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 15 --

	encounter_forsaken_pit =
	{
		szMapNames = { "aghs2_encounters/a3_3_forsaken_pit", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_burning_mesa =
	{
		szMapNames = { "aghs2_encounters/a3_3_burning_mesa", },
		nEncounterType = ROOM_TYPE_ENEMY,
		--HACK DO NOT SHIP ME nRequiredAscension = AGHANIM_ASCENSION_MAGICIAN,
	},

	encounter_smashy_and_bashy =
	{
		szMapNames = { "aghs2_encounters/a3_3_underwater_fortress", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_push_pull =
	{
		szMapNames = { "aghs2_encounters/a3_3_push_pull", },
		nEncounterType = ROOM_TYPE_ENEMY,
	},

	encounter_jungle_traps =
	{
		szMapNames = { "aghs2_encounters/a3_3_jungle_traps", },
		nEncounterType = ROOM_TYPE_TRAPS,
	},

	-- Depth 16 --

	encounter_transition_gateway =
	{
		szMapNames = { "aghs2_encounters/a3_4_transition_gateway", },
		nEncounterType = ROOM_TYPE_TRANSITIONAL,
	},

	-- Depth 17 --
	encounter_primal_beast =
	{
		szMapNames = { "aghs2_encounters/a3_4_primal_beast", },
		nEncounterType = ROOM_TYPE_BOSS,
	},

	-- Event Encounters --
	encounter_event_minor_shard_shop =
	{
		szMapNames = { "aghs2_encounters/oracle_sanctum", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_doom_life_swap =
	{
		szMapNames = { "aghs2_encounters/dooms_soulforge", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_warlock_library =
	{
		szMapNames = { "aghs2_encounters/warlock_arcane_archives", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_alchemist_neutral_items =
	{
		szMapNames = { "aghs2_encounters/alchemist_chemical_lab", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_brewmaster_bar =
	{
		szMapNames = { "aghs2_encounters/brewmaster_bar", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_life_shop =
	{
		szMapNames = { "aghs2_encounters/roshan_pit", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_morphling_attribute_shift =
	{
		szMapNames = { "aghs2_encounters/soggy_sinkhole", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_tinker_range_retrofit =
	{
		szMapNames = { "aghs2_encounters/retrofit_room", },
		nEncounterType = ROOM_TYPE_EVENT,
	},
	encounter_event_naga_bottle_rune =
	{
		szMapNames = { "aghs2_encounters/rune_river", },
		nEncounterType = ROOM_TYPE_EVENT,
	},

	encounter_event_slark =
	{
		szMapNames = { "aghs2_encounters/slark_tidepools", },
		nEncounterType = ROOM_TYPE_EVENT,
	},

	encounter_event_zeus =
	{
		szMapNames = { "aghs2_encounters/zeus_temple", },
		nEncounterType = ROOM_TYPE_EVENT,
	},

	encounter_event_leshrac =
	{
		szMapNames = { "aghs2_encounters/leshrac_weald", },
		nEncounterType = ROOM_TYPE_EVENT,
	},

	encounter_event_necrophos =
	{
		szMapNames = { "aghs2_encounters/necrophos_shrine", },
		nEncounterType = ROOM_TYPE_EVENT,
	},

	encounter_event_small_tiny_shrink =
	{
		szMapNames = { "aghs2_encounters/pebbles_pit", },
		nEncounterType = ROOM_TYPE_EVENT,
		szDisableEvents = { "encounter_event_big_tiny_grow", },
	},

	encounter_event_big_tiny_grow =
	{
		szMapNames = { "aghs2_encounters/pebbletons_peak", },
		nEncounterType = ROOM_TYPE_EVENT,
		szDisableEvents = { "encounter_event_small_tiny_shrink", },
	},

	encounter_event_ogre_magi_casino =
	{
		szMapNames = { "aghs2_encounters/jungle_casino", },
		nEncounterType = ROOM_TYPE_EVENT,
	},

	-- Test --

	-- Debug --
	encounter_test_immediate_victory =
	{
		nEncounterType = ROOM_TYPE_ENEMY,
	},
	encounter_test_immediate_victory_event =
	{
		nEncounterType = ROOM_TYPE_EVENT,
	},

	
}

-- If you want a particular unit to have a different model scale, put it here
_G.ENCOUNTER_PREVIEW_SCALES =
{
	npc_dota_creature_bonus_chicken = 2.5,
	npc_dota_creature_shroom_giant = 1.5,
	npc_dota_creature_year_beast = 0.55,
	npc_dota_creature_bonus_pig = 1.75,
	npc_dota_creature_huge_axe = .95,
	npc_dota_creature_drow_ranger_miniboss = 1.35,
	npc_dota_creature_venomancer = 0.85,
	npc_dota_creature_big_skeleton = 1.35,
	npc_dota_creature_large_ogre_seal_diretide = 0.75,
	npc_dota_creature_polarity_ghost_captain_positive = 0.7,
	npc_dota_creature_amoeba_boss = 0.8,
	npc_dota_creature_amoeba_boss_effigy = 0.4,
	npc_dota_creature_aghsfort_primal_beast_boss = 0.4,
	npc_dota_creature_brewmaster_bartender = 1.0,
	npc_dota_creature_event_big_tiny = 1.25,
	npc_dota_creature_alchemist_event = 1.15,
	npc_dota_creature_zealot_scarab = 1.45,
	npc_dota_creature_nightstalker_miniboss = .75,
	npc_dota_breathe_fire_trap = .925,
	npc_dota_arrow_trap = .925,
	npc_dota_spike_trap_ward = .45,
	npc_dota_creature_treant_miniboss = .75,
	npc_dota_crypt_gate_skeleton = 1.75,
	npc_dota_creature_golem_tower = .8,
	npc_dota_creature_phantom_lancer = 1.25,
	npc_dota_creature_life_stealer = 1.15,
	npc_dota_creature_phoenix = 0.85,
	npc_dota_creature_ice_boss = .85,
	npc_dota_boss_visage = .8,
	npc_dota_boss_earthshaker = .9,
	npc_dota_boss_clockwerk = 1.35,
	npc_dota_boss_tinker = 1.0,
	npc_dota_aghsfort_arc_warden_boss = 1.1,
	npc_aghsfort_morty_mango_orchard = .6,
	npc_dota_creature_bonus_pudge = 1.0,
	npc_dota_creature_acid_blob = .9,
	npc_dota_creature_acid_blob_effigy = .825,
	npc_dota_creature_bear_cave_ursa = 1.0,
	npc_dota_creature_monkey_king = .9,
	npc_dota_shop_keeper = 1.25,
	npc_dota_creature_outworld = .85,
	npc_dota_creature_phantom_lancer = 1.2,
	npc_dota_creature_large_eimermole = 1.35,
	npc_dota_creature_tinker_turret = 1.0,
	npc_dota_creature_leshrac = 1.0,
	npc_dota_creature_pudge_miniboss = 1.2,
	npc_aghsfort_creature_bomb_squad = 0.65,
	npc_dota_tusk_boss = 1.15,
	npc_dota_creature_mars = .9,
	npc_dota_creature_rock_golem_a = .95,
	npc_dota_creature_gaoler = .85,
	npc_dota_creature_event_zeus = 1.35,
	npc_dota_creature_warlock_librarian = 1.25,
	npc_dota_creature_tinker_event = 1.0,
	npc_dota_creature_event_small_tiny = 1.9,
	npc_dota_creature_event_slark = 1.50,
	npc_dota_hero_doom_bringer = .85,
	npc_dota_creature_naga_siren_event = 1.1,
	npc_dota_creature_morphling_event = 1.1,
	npc_dota_creature_shard_shop_oracle = .875,
	npc_dota_shop_keeper_lost_meepo = 1.0,
	npc_dota_creature_doom_soultrader = .75,
	npc_dota_creature_polarity_ghost_captain_positive = 1.0,
	npc_dota_pinecone_champion = 1.0,
	npc_dota_giant_wendigo = 1.0,
	npc_dota_creature_weaver = 1.1,
	npc_dota_creature_alchemist = 1.15,
	npc_dota_creature_thundergod_zeus = 1.4,
	npc_dota_creature_temple_guardian = 1.25,
	npc_dota_creature_storegga = .65,
	npc_aghsfort_morty = .75,
	npc_dota_creature_catapult = 0.75,
	npc_dota_creature_snapfire = .65,
	npc_dota_creature_slardar_smashy = 1.025,
	npc_dota_creature_dire_hound_boss = 1.3,
	npc_dota_creature_crystal_maiden_miniboss = 1.3,
	npc_dota_creature_diregull = 0.7,
	npc_dota_creature_aziyog_underlord = .85,
	npc_dota_creature_stonehall_general = 1.15,
	npc_dota_sled_penguin = 3.0,
	npc_dota_creature_bandit_captain = 1.25,
	npc_dota_creature_dark_willow_boss = 1,
	npc_dota_creature_bonus_hoodwink = 1.5,
	npc_dota_boss_timbersaw = .525,
}

-- if you want to adjust an effigy's position 
-- "n"
_G.ENCOUNTER_EFFIGY_OFFSETS =
{
	npc_dota_creature_bonus_chicken = Vector( 0, 0, 42 ),
	npc_dota_creature_shroom_giant = Vector( -10, 0, 42 ),
	npc_dota_creature_year_beast = Vector( -30, 0, 42 ),
	npc_dota_creature_bonus_pig = Vector( 0, 0, 42 ),
	npc_dota_creature_huge_axe = Vector( 0, 0, 42 ),
	npc_dota_creature_drow_ranger_miniboss = Vector( -16, 0, 42 ),
	npc_dota_creature_venomancer = Vector( 0, 0, 42 ),
	npc_dota_creature_big_skeleton = Vector( 0, 0, 42 ),
	npc_dota_creature_large_ogre_seal_diretide = Vector( -30, 0, 42 ),
	npc_dota_creature_polarity_ghost_captain_positive = Vector( 0, 0, 42 ),
	npc_dota_creature_amoeba_boss = Vector( 0, 0, 42 ),
	npc_dota_creature_amoeba_boss_effigy = Vector( 0, 0, 42 ),
	npc_dota_creature_aghsfort_primal_beast_boss = Vector( 0, 0, 42 ),
	npc_dota_creature_brewmaster_bartender = Vector( 0, 0, 42 ),
	npc_dota_creature_event_big_tiny = Vector( 0, 0, 42 ),
	npc_dota_creature_alchemist_event = Vector( 0, 0, 42 ),
	npc_dota_creature_zealot_scarab = Vector( 0, 0, 42 ),
	npc_dota_creature_nightstalker_miniboss = Vector( -16, 0, 42 ),
	npc_dota_breathe_fire_trap = Vector( 0, 0, 42 ),
	npc_dota_arrow_trap = Vector( 0, 0, 42 ),
	npc_dota_spike_trap_ward = Vector( 0, 0, 56 ),
	npc_dota_creature_treant_miniboss = Vector( -8, 0, 42 ),
	npc_dota_crypt_gate_skeleton = Vector( 0, 0, 42 ),
	npc_dota_creature_golem_tower = Vector( -16, 0, 42 ),
	npc_dota_creature_phantom_lancer = Vector( 0, 0, 42 ),
	npc_dota_creature_life_stealer = Vector( -24, 0, 42 ),
	npc_dota_creature_phoenix = Vector( -8, 0, 42 ),
	npc_dota_creature_ice_boss = Vector( 0, 0, 42 ),
	npc_dota_boss_visage = Vector( 0, 0, 42 ),
	npc_dota_boss_earthshaker = Vector( 0, 0, 42 ),
	npc_dota_boss_clockwerk = Vector( 0, 0, 42 ),
	npc_dota_aghsfort_arc_warden_boss = Vector( 0, 0, 42 ),
	npc_aghsfort_morty_mango_orchard = Vector( 42, 0, 42 ),
	npc_dota_creature_bonus_pudge = Vector( 0, 0, 42 ),
	npc_dota_creature_acid_blob = Vector( 0, 0, 42 ),
	npc_dota_creature_acid_blob_effigy = Vector( 0, 0, 42 ),
	npc_dota_creature_bear_cave_ursa = Vector( -40, 0, 42 ),
	npc_dota_creature_monkey_king = Vector( -16, 0, 42 ),
	npc_dota_shop_keeper = Vector( 0, 0, 42 ),
	npc_dota_creature_outworld = Vector( 0, 0, 42 ),
	npc_dota_creature_phantom_lancer = Vector( 0, 0, 42 ),
	npc_dota_creature_large_eimermole = Vector( 0, 0, 42 ),
	npc_dota_creature_tinker_turret = Vector( 0, 0, 42 ),
	npc_dota_creature_leshrac = Vector( 0, 0, 42 ),
	npc_dota_creature_pudge_miniboss = Vector( 0, 0, 42 ),
	npc_aghsfort_creature_bomb_squad = Vector( 0, 0, 42 ),
	npc_dota_tusk_boss = Vector( 0, 0, 42 ),
	npc_dota_creature_mars = Vector( -36, 0, 42 ),
	npc_dota_creature_rock_golem_a = Vector( 0, 0, 42 ),
	npc_dota_creature_gaoler = Vector( 0, 0, 42 ),
	npc_dota_creature_event_zeus = Vector( 0, 0, 42 ),
	npc_dota_creature_warlock_librarian = Vector( 0, 0, 42 ),
	npc_dota_creature_tinker_event = Vector( 0, 0, 42 ),
	npc_dota_creature_event_small_tiny = Vector( 0, 0, 42 ),
	npc_dota_creature_event_slark = Vector( 0, 0, 42 ),
	npc_dota_hero_doom_bringer = Vector( 0, 0, 42 ),
	npc_dota_creature_naga_siren_event = Vector( 0, 0, 42 ),
	npc_dota_creature_morphling_event = Vector( 0, 0, 42 ),
	npc_dota_creature_shard_shop_oracle = Vector( 0, 0, 42 ),
	npc_dota_shop_keeper_lost_meepo = Vector( 0, 0, 42 ),
	npc_dota_creature_doom_soultrader = Vector( 0, 0, 42 ),
	npc_dota_creature_polarity_ghost_captain_positive = Vector( 0, 0, 42 ),
	npc_dota_pinecone_champion = Vector( 0, 0, 42 ),
	npc_dota_giant_wendigo = Vector( 0, 0, 42 ),
	npc_dota_creature_weaver = Vector( 0, 0, 42 ),
	npc_dota_creature_alchemist = Vector( 0, 0, 42 ),
	npc_dota_creature_thundergod_zeus = Vector( 0, 0, 42 ),
	npc_dota_creature_temple_guardian = Vector( 0, 0, 42 ),
	npc_dota_creature_storegga = Vector( 0, 0, 42 ),
	npc_aghsfort_morty = Vector( -40, 0, 42 ),
	npc_dota_creature_catapult = Vector( 0, 0, 23 ),
	npc_dota_creature_snapfire = Vector( -40, 0, 42 ),
	npc_dota_creature_slardar_smashy = Vector( 0, 0, 42 ),
	npc_dota_creature_dire_hound_boss = Vector( 0, 0, 42 ),
	npc_dota_creature_diregull = Vector ( -20, 0, 42),
	npc_dota_creature_aziyog_underlord = Vector ( -18, 0, 42),
	npc_dota_creature_stonehall_general = Vector ( 0, 0, 42),
	npc_dota_sled_penguin = Vector ( 0, 0, 42),
	npc_dota_creature_bandit_captain = Vector ( 0, 0, 42),
	npc_dota_creature_dark_willow_boss = Vector ( 0, 0, 20),
	npc_dota_boss_timbersaw = Vector ( 0, 0, 42),
}

-- For debugging at the moment, a fixed layout of rooms
_G.USE_ENCOUNTER_FIXED_LAYOUT = false

_G.ENCOUNTER_FIXED_LAYOUT =
{
}

_G.MAP_ENTRANCE_HEIGHTS =
{
	a1_1_bears_lair = -384.0,
	a1_1_pine_grove = -256.0,
	a1_2_sacred_grounds = -128.0,
	a1_2_deep_traps = -128.0,
	a1_2_regal_traps = -128.0,
	a1_3_blob_dungeon = -128.0,
	a1_3_desert_oasis = -128.0,
	a1_4_catacombs = -128.0,
	a1_4_cavern_traps = -128.0,
	a1_4_aziyog_caverns = -128,
	a1_6_bonus_hooking = -256.0,
	a1_3_mole_cave = -256.0,
	a2_1_marine_prison = -128.0,
	a2_1_mushroom_mines = -128.0,
	a2_2_ruinous_traps = -128.0,
	a2_2_beach_traps = -256.0,
	a2_2_crystal_forest = -128.0,
	a2_3_canyon_pass = -128.0,
	a2_3_stonehall_citadel = -128.0,
	a2_5_amoeba = -128.0,
	a2_6_bonus_livestock = -128.0,
	a2_6_bonus_chicken_smashing = -128.0,
	a3_1_hidden_colosseum = -128.0,
	a3_1_palace_traps = -256.0,
	a3_2_village_traps = -128.0,
	a3_3_forsaken_pit = -384.0,
	a3_3_push_pull = -128.0,
	a3_4_primal_beast = -384.0,
	warlock_arcane_archives = -128,
	slark_tidepools = -128,
	pebbles_pit = -256,
}

_G.MAP_EXIT_HEIGHTS =
{
	a1_1_bears_lair = -384.0,
	a1_1_pine_grove = -256.0,
	a1_2_sacred_grounds = -128.0,
	a1_2_regal_traps = -128.0,
	a1_3_blob_dungeon = -128.0,
	a1_3_desert_oasis = -128.0,
	a1_4_catacombs = -128.0,
	a1_4_cavern_traps = -128.0,
	a1_4_aziyog_caverns = -128,
	a1_6_bonus_hooking = -256.0,
	a1_3_mole_cave = -256.0,
	a1_5_timbersaw = -256.0,
	a2_1_marine_prison = -128.0,
	a2_1_mushroom_mines = -128.0,
	a2_2_ruinous_traps = -128.0,
	a2_2_beach_traps = -256.0,
	a2_2_crystal_forest = -128.0,
	a2_3_stonehall_citadel = -128.0,
	a2_3_canyon_pass = -128.0,
	a2_5_amoeba = -128.0,
	a2_6_bonus_livestock = -128.0,
	a3_1_hidden_colosseum = -128.0,
	a3_1_palace_traps = -256.0,
	a3_2_village_traps = -128.0,
	a3_2_frigid_pinnacle = -512.0,
	a3_3_forsaken_pit = -384.0,
	a3_3_push_pull = -128.0,
	a3_4_primal_beast = -256.0,
	warlock_arcane_archives = -128,
	slark_tidepools = -128,
	pebbles_pit = -256,
}