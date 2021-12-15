require( "constants" )

_G.MAP_ATLAS_ROOM_SIZE = 4096
_G.MAP_ATLAS_ACT2_OFFSET = 1536
_G.MAP_ATLAS_ELITE_ROOMS_PER_ACT =
{
	-- NOTE: Indexed by ascension level
	{
		0, 1, 2
	},
	{
		2, 3, 3
	},
	{
		3, 3, 3
	},	
	{
		3, 3, 3
	},	
	{
		3, 4, 4
	},	
}
_G.MAP_TRAP_ROOMS_PER_ACT =
{
	1, 1, 1
}
_G.MAP_HIDDEN_ENCOUNTERS_PER_ACT =
{
	3, 3, 3
}

-- Starting bottom left
_G.MAP_ATLAS =
{
	--
	-- Act 1
	--

	a1_1a =
	{
		name="a1_1a",
		exit_up="a1_2a",
		exit_side="a1_2b",
		nRoomType = ROOM_TYPE_STARTING,
		bCannotBeElite = true,
		nDepth = 1,
		vCenter = Vector( -7 * MAP_ATLAS_ROOM_SIZE / 2, -7 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a1_2a =
	{
		name="a1_2a",
		exit_up="a1_3a",
		exit_side="a1_3b",
		nRoomType = ROOM_TYPE_ENEMY,
		bCannotBeTrap = true,
		nDepth = 2,
		vCenter = Vector( -7 * MAP_ATLAS_ROOM_SIZE / 2, -5 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a1_2b =
	{
		name="a1_2b",
		exit_up="a1_3b",
		exit_side="a1_3c",
		nRoomType = ROOM_TYPE_ENEMY,
		bCannotBeTrap = true,
		nDepth = 2,
		vCenter = Vector( -5 * MAP_ATLAS_ROOM_SIZE / 2, -7 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	

	a1_3a =
	{
		name="a1_3a",
		exit_up="a1_4a",
		exit_side="a1_4b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 3,
		vCenter = Vector( -7 * MAP_ATLAS_ROOM_SIZE / 2, -3 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a1_3b =
	{
		name="a1_3b",
		exit_up="a1_4b",
		exit_side="a1_4c",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 3,
		vCenter = Vector( -5 * MAP_ATLAS_ROOM_SIZE / 2, -5 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a1_3c =
	{
		name="a1_3c",
		exit_up="a1_4c",
		exit_side="a1_4d",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 3,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE / 2, -7 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a1_4a =
	{
		name="a1_4a",
		exit_side="a1_5a",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 4,
		vCenter = Vector( -7 * MAP_ATLAS_ROOM_SIZE / 2, -1 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a1_4b =
	{
		name="a1_4b",
		exit_up="a1_5a",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 4,
		vCenter = Vector( -5 * MAP_ATLAS_ROOM_SIZE / 2, -3 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a1_4c =
	{
		name="a1_4c",
		exit_side="a1_5b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 4,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE / 2, -5 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a1_4d =
	{
		name="a1_4d",
		exit_up="a1_5b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 4,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE / 2, -7 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a1_5a =
	{
		name="a1_5a",
		exit_side="a1_boss",
		nRoomType = ROOM_TYPE_ENEMY,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 5,
		vCenter = Vector( -5 * MAP_ATLAS_ROOM_SIZE / 2, -1 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a1_5b =
	{
		name="a1_5b",
		exit_up="a1_boss",
		nRoomType = ROOM_TYPE_ENEMY,
		bCannotBeTrap = true,
		bCannotBeElite = true,
		nDepth = 5,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE / 2, -5 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a1_boss =
	{
		name="a1_boss",
		exit_side="a2_transition",
		nRoomType = ROOM_TYPE_BOSS,
		bCannotBeElite = true,
		nDepth = 6,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE, -1 * MAP_ATLAS_ROOM_SIZE, 0 ),
		vSize = Vector( 2 * MAP_ATLAS_ROOM_SIZE, 2 * MAP_ATLAS_ROOM_SIZE, 0 )
	},

	--
	-- Transition Act 1 -> Act 2
	--

	a2_transition =
	{
		name="a2_transition",
		exit_up="a2_1a",
		nRoomType = ROOM_TYPE_BONUS,
		bCannotBeElite = true,
		nDepth = 7,
		vCenter = Vector( 2 * MAP_ATLAS_ROOM_SIZE, -11 * MAP_ATLAS_ROOM_SIZE / 4 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( 4 * MAP_ATLAS_ROOM_SIZE, 3 * MAP_ATLAS_ROOM_SIZE / 2, 0 )
	},

	--
	-- Act 2
	--
	a2_1a =
	{
		name="a2_1a",
		exit_up="a2_2a",
		exit_side="a2_2b",
		nRoomType = ROOM_TYPE_ENEMY,
		bCannotBeElite = true,
		bCannotBeTrap = true,
		nDepth = 8,
		vCenter = Vector( 7 * MAP_ATLAS_ROOM_SIZE / 2, -3 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a2_2a =
	{
		name="a2_2a",
		exit_up="a2_3a",
		exit_side="a2_3b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 9,
		vCenter = Vector( 7 * MAP_ATLAS_ROOM_SIZE / 2, -1 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a2_2b =
	{
		name="a2_2b",
		exit_up="a2_3b",
		exit_side="a2_3c",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 9,
		vCenter = Vector( 5 * MAP_ATLAS_ROOM_SIZE / 2, -3 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	

	a2_3a =
	{
		name="a2_3a",
		exit_up="a2_4a",
		exit_side="a2_4b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 10,
		vCenter = Vector( 7 * MAP_ATLAS_ROOM_SIZE / 2, 1 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a2_3b =
	{
		name="a2_3b",
		exit_up="a2_4b",
		exit_side="a2_4c",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 10,
		vCenter = Vector( 5 * MAP_ATLAS_ROOM_SIZE / 2, -1 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a2_3c =
	{
		name="a2_3c",
		exit_up="a2_4c",
		exit_side="a2_4d",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 10,
		vCenter = Vector( 3 * MAP_ATLAS_ROOM_SIZE / 2, -3 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a2_4a =
	{
		name="a2_4a",
		exit_side="a2_5a",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 11,
		vCenter = Vector( 7 * MAP_ATLAS_ROOM_SIZE / 2, 3 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a2_4b =
	{
		name="a2_4b",
		exit_up="a2_5a",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 11,
		vCenter = Vector( 5 * MAP_ATLAS_ROOM_SIZE / 2, 1 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a2_4c =
	{
		name="a2_4c",
		exit_side="a2_5b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 11,
		vCenter = Vector( 3 * MAP_ATLAS_ROOM_SIZE / 2, -1 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a2_4d =
	{
		name="a2_4d",
		exit_up="a2_5b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 11,
		vCenter = Vector( 1 * MAP_ATLAS_ROOM_SIZE / 2, -3 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a2_5a =
	{
		name="a2_5a",
		exit_side="a2_boss",
		nRoomType = ROOM_TYPE_TRANSITIONAL,
		bCannotBeElite = true,
		nDepth = 12,
		vCenter = Vector( 5 * MAP_ATLAS_ROOM_SIZE / 2, 3 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a2_5b =
	{
		name="a2_5b",
		exit_up="a2_boss",
		nRoomType = ROOM_TYPE_TRANSITIONAL,
		bCannotBeElite = true,
		nDepth = 12,
		vCenter = Vector( 1 * MAP_ATLAS_ROOM_SIZE / 2, -1 * MAP_ATLAS_ROOM_SIZE / 2 + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a2_boss =
	{
		name="a2_boss",
		exit_side="a3_1a",
		nRoomType = ROOM_TYPE_BOSS,
		bCannotBeElite = true,
		nDepth = 13,
		vCenter = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE + MAP_ATLAS_ACT2_OFFSET, 0 ),
		vSize = Vector( 2 * MAP_ATLAS_ROOM_SIZE, 2 * MAP_ATLAS_ROOM_SIZE, 0 )
	},

	--
	-- Act 3
	--
	a3_1a =
	{
		name="a3_1a",
		exit_up="a3_2a",
		exit_side="a3_2b",
		nRoomType = ROOM_TYPE_BONUS,
		bCannotBeElite = true,
		nDepth = 14,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE / 2, 1 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a3_2a =
	{
		name="a3_2a",
		exit_up="a3_3a",
		exit_side="a3_3b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 15,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE / 2, 3 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a3_2b =
	{
		name="a3_2b",
		exit_up="a3_3b",
		exit_side="a3_3c",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 15,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE / 2, 1 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	

	a3_3a =
	{
		name="a3_3a",
		exit_up="a3_4a",
		exit_side="a3_4b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 16,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE / 2, 5 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a3_3b =
	{
		name="a3_3b",
		exit_up="a3_4b",
		exit_side="a3_4c",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 16,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE / 2, 3 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a3_3c =
	{
		name="a3_3c",
		exit_up="a3_4c",
		exit_side="a3_4d",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 16,
		vCenter = Vector( -5 * MAP_ATLAS_ROOM_SIZE / 2, 1 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a3_4a =
	{
		name="a3_4a",
		exit_side="a3_5a",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 17,
		vCenter = Vector( -1 * MAP_ATLAS_ROOM_SIZE / 2, 7 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a3_4b =
	{
		name="a3_4b",
		exit_up="a3_5a",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 17,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE / 2, 5 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a3_4c =
	{
		name="a3_4c",
		exit_side="a3_5b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 17,
		vCenter = Vector( -5 * MAP_ATLAS_ROOM_SIZE / 2, 3 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},
	a3_4d =
	{
		name="a3_4d",
		exit_up="a3_5b",
		nRoomType = ROOM_TYPE_ENEMY,
		nDepth = 17,
		vCenter = Vector( -7 * MAP_ATLAS_ROOM_SIZE / 2, 1 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a3_5a =
	{
		name="a3_5a",
		exit_side="a3_boss",
		nRoomType = ROOM_TYPE_TRANSITIONAL,
		bCannotBeElite = true,
		nDepth = 18,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE / 2, 7 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},	
	a3_5b =
	{
		name="a3_5b",
		exit_up="a3_boss",
		nRoomType = ROOM_TYPE_TRANSITIONAL,
		bCannotBeElite = true,
		nDepth = 18,
		vCenter = Vector( -7 * MAP_ATLAS_ROOM_SIZE / 2, 3 * MAP_ATLAS_ROOM_SIZE / 2, 0 ),
		vSize = Vector( MAP_ATLAS_ROOM_SIZE, MAP_ATLAS_ROOM_SIZE, 0 )
	},

	a3_boss =
	{
		name="a3_boss",
		nRoomType = ROOM_TYPE_BOSS,
		bCannotBeElite = true,
		nDepth = 19,
		vCenter = Vector( -3 * MAP_ATLAS_ROOM_SIZE, 3 * MAP_ATLAS_ROOM_SIZE, 0 ),
		vSize = Vector( 2 * MAP_ATLAS_ROOM_SIZE, 2 * MAP_ATLAS_ROOM_SIZE, 0 )
	},	
}

_G.ENCOUNTER_DEFINITIONS =
{
	-- Spawn room encounter
	encounter_starting_room =
	{
		nEncounterType = ROOM_TYPE_STARTING,
		nMinDepth = 1,
		nMaxDepth = 1,
	},

	-- Normal encounters
	encounter_empty_cavern =
	{	
		szMapNames = { "empty_cavern" },
		nEncounterType = ROOM_TYPE_TRANSITIONAL,
		nMinDepth = 12,
		nMaxDepth = 12,
	},

	encounter_empty_beach =
	{	
		szMapNames = { "empty_beach" },
		nEncounterType = ROOM_TYPE_TRANSITIONAL,
		nMinDepth = 18,
		nMaxDepth = 18,
	},
	encounter_brewmaster =
	{
		szMapNames = { "radiant_ring" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},
	encounter_hellbears_portal_v3 =
	{
		szMapNames = { "fodder_arena2" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},
	encounter_pinecones =
	{
		szMapNames = { "fodder_random_portals", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},
	encounter_quill_beasts =
	{
		szMapNames = { "radiant_forest", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},
	encounter_jungle_hijinx =
	{
		szMapNames = { "jungle_hijinx" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 3,
		nMaxDepth = 3,
	},
	encounter_tusk_skeletons =
	{
		szMapNames = { "defend_highground_snow", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 3,
		nMaxDepth = 3,
	},
	encounter_bombers =
	{
		szMapNames = { "defend_highground" }, -- Need a "trigger_spawn_creatures" trigger
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 3,
		nMaxDepth = 3,
	},
	encounter_drow_ranger_miniboss =
	{
		szMapNames = { "drow_ranger_miniboss" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 3,
		nMaxDepth = 3,
	},
	encounter_wave_blasters =
	{
		szMapNames = { "arena" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 4,
		nMaxDepth = 4,
	},
	encounter_baby_ogres =
	{
		szMapNames = { "baby_ogres", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 4,
		nMaxDepth = 4,
	},
	encounter_morphlings_b =
	{
		szMapNames = { "shoal", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 4,
		nMaxDepth = 4,
	},
	encounter_zealot_scarabs =
	{
		szMapNames = { "desert_oasis" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 4,
		nMaxDepth = 4,
	},

	encounter_ogre_seals =
	{
		szMapNames = { "snowy_river" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 5,
		nMaxDepth = 5,
	},
	encounter_warlocks =
	{
		szMapNames = { "scorched_plain" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 5,
		nMaxDepth = 5,
	},
	encounter_gauntlet =
	{
		szMapNames = { "catacombs", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 5,
		nMaxDepth = 5,
	},

	-- Act 2

	encounter_morty_transition =
	{
		szMapNames = { "morty_transition" },
		nEncounterType = ROOM_TYPE_BONUS,
		nMinDepth = 7,
		nMaxDepth = 7,
	},
	encounter_penguins_transition =
	{
		szMapNames = { "penguins_transition" },
		nEncounterType = ROOM_TYPE_BONUS,
		nMinDepth = 7,
		nMaxDepth = 7,
	},

	encounter_mirana =
	{
		szMapNames = { "plains" },	-- If you add more here, make sure there are info_target "retreat_point" entities authored in the map
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 8,
		nMaxDepth = 8,
	},
	encounter_mushroom_mines =
	{
		szMapNames = { "mushroom_mines" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 8,
		nMaxDepth = 8,
	},
	encounter_legion_commander = 
	{
		szMapNames = { "radiant_stadium" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 8,
		nMaxDepth = 8,
	},

	encounter_troll_warlord = 
	{
		szMapNames = { "dire_trading_post" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 9,
		nMaxDepth = 9,
	},
	encounter_pudge_miniboss =
	{
		szMapNames = { "pudge_defend_lowground" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 9,
		nMaxDepth = 9,
	},
	encounter_pucks =
	{
		szMapNames = { "meadow" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 9,
		nMaxDepth = 9,
	},
	encounter_dark_seer =
	{
		szMapNames = { "frozen_cliffs" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 9,
		nMaxDepth = 9,
	},

	encounter_spectres =
	{
		szMapNames = { "gloom" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 10,
		nMaxDepth = 10,
	},
	encounter_shadow_demons =
	{
		szMapNames = { "shadow_demon_forest" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 10,
		nMaxDepth = 10,
	},
	encounter_rock_golems =
	{
		szMapNames = { "mines_arena" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 10,
		nMaxDepth = 10,
	},

	encounter_naga_siren =
	{
		szMapNames = { "defend_lowground" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 10,
		nMaxDepth = 10,
	},

	encounter_dire_siege =
	{
		szMapNames = { "a2_gauntlet" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 11,
		nMaxDepth = 11,
	},
	encounter_big_ogres =
	{
		szMapNames = { "bog", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 11,
		nMaxDepth = 11,
	},
	encounter_dragon_knight =
	{
		szMapNames = { "fortress", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 11,
		nMaxDepth = 11,
	},

	encounter_kunkka_tide =
	{
		szMapNames = { "coastal_arena", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 11,
		nMaxDepth = 11,
	},

	-- Act 3
	encounter_alchemist =
	{
		szMapNames = { "chemlab" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 15,
		nMaxDepth = 15,
	},

	encounter_enraged_wildwings =
	{
		szMapNames = { "wildwings_arena" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 15,
		nMaxDepth = 15,
	},
	encounter_elemental_tiny =
	{
		szMapNames = { "tiny_arena" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 15,
		nMaxDepth = 15,
	},

	encounter_bandits =
	{
		szMapNames = { "badlands" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 16,
		nMaxDepth = 16,
	},
	encounter_bomb_squad =
	{
		szMapNames = { "snowy_portals" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 16,
		nMaxDepth = 16,
	},
	encounter_undead_woods =
	{
		szMapNames = { "undead_woods" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 16,
		nMaxDepth = 16,
	},

	encounter_phoenix =
	{
		szMapNames = { "burning_mesa" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 17,
		nMaxDepth = 17,
	},
	encounter_broodmothers =
	{
		szMapNames = { "spider_cave" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 17,
		nMaxDepth = 17,
	},

	encounter_fire_roshan =
	{
		szMapNames = { "underground_cave" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 17,
		nMaxDepth = 17,
	},

	-- Bosses
	--[[
	encounter_boss_visage =
	{
		szMapNames = { "mausoleum" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 6,
		nMaxDepth = 6,
	}, 
	]]
	encounter_boss_timbersaw =
	{
		szMapNames = { "forest_hill_boss" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 6,
		nMaxDepth = 6,
	},
	encounter_temple_guardians =
	{
		szMapNames = { "floating_chamber_boss2" },
		szFlippedMapNames = { "template_boss_r_to_l" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 6,
		nMaxDepth = 6,
	},
	--[[encounter_tusk_boss =
	{
		szMapNames = { "tusk_boss" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 6,
		nMaxDepth = 6,
	},--]]

	encounter_storegga =
	{
		szMapNames = { "boss_island_r_to_l" },
		szFlippedMapNames = { "template_boss_l_to_r" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 13,
		nMaxDepth = 13,
	},
	encounter_boss_void_spirit =
	{
		szMapNames = { "boss_void_spirit" },
		szFlippedMapNames = { "template_boss_l_to_r" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 13,
		nMaxDepth = 13,
	},

	encounter_aghanim =
	{
		szMapNames = { "aghanim_arena2" },
		nEncounterType = ROOM_TYPE_BOSS,
		nMinDepth = 19,
		nMaxDepth = 19,
	},

	-- encounter_rhyzik =
	-- {
	-- 	szMapNames = { "boss_island_r_to_l" },
	-- 	szFlippedMapNames = { "template_boss_l_to_r" },
	-- 	nEncounterType = ROOM_TYPE_BOSS,
	-- 	nMinDepth = 19,
	-- 	nMaxDepth = 19,
	-- },

	-- Traps
	encounter_jungle_fire_maze =
	{
		szMapNames = { "jungle_fire_maze" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 3,
		nMaxDepth = 6,
	},

	encounter_cliff_pass =
	{
		szMapNames = { "desert_cliff_pass" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 3,
		nMaxDepth = 6,
	},

	encounter_hellfire_canyon =
	{
		szMapNames = { "hellfire_canyon" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 8,
		nMaxDepth = 12,
	},

	encounter_temple_garden =
	{
		szMapNames = { "temple_garden_traps" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 8,
		nMaxDepth = 12,
	},

	encounter_castle_traps =
	{
		szMapNames = { "castle_traps" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 15,
		nMaxDepth = 17,
	},

	encounter_crypt_traps =
	{
		szMapNames = { "crypt_traps" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 15,
		nMaxDepth = 17,
	},

	--[[
	encounter_wrath =
	{
		szMapNames = { "kerblam" },
		nEncounterType = ROOM_TYPE_TRAPS,
		nMinDepth = 7,
		nMaxDepth = 19,
	},
	]]

	-- Transitions
	--[[
	encounter_transition =
	{
		szMapNames = { "template_transitional_l_to_r" },
		szFlippedMapNames = { "template_transitional_r_to_l" },
		nEncounterType = ROOM_TYPE_BONUS,
		nMinDepth = 1,
		nMaxDepth = 19,
	},
	]]

	-- Reward room encounter
	--[[
	encounter_test_reward_room =
	{
		szMapNames = { "template" },
		nEncounterType = ROOM_TYPE_BONUS,
		nMinDepth = 2,
		nMaxDepth = 19,
	},
	]]

	encounter_bonus_chicken =
	{
		szMapNames = { "defend_highground_chickens" },	-- Need a "trigger_spawn_creatures" trigger
		nEncounterType = ROOM_TYPE_BONUS,
		nMinDepth = 14,
		nMaxDepth = 14,
	},

	encounter_pangolier =
	{
		szMapNames = { "temple_arena" },  -- Need a "trigger_spawn_creatures" trigger
		nEncounterType = ROOM_TYPE_BONUS,
		nMinDepth = 14,
		nMaxDepth = 14,
	},




	-- CUT ENCOUNTERS
	--[[
	encounter_hellbears_portal_v2 =
	{
		szMapNames = { "fodder_arena2" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},
	
	encounter_hellbears =
	{
		szMapNames = { "fodder_arena2" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},

	encounter_enraged_hellbears =
	{
		szMapNames = { "fodder_arena", },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 2,
		nMaxDepth = 2,
	},
	]]--

	--[[
	encounter_wildwings =
	{
		szMapNames = { "fodder_arena2" },
		nEncounterType = ROOM_TYPE_ENEMY,
		nMinDepth = 3,
		nMaxDepth = 3,
	}, 
	]]--

}

-- Used to specify exit heights for particular maps
_G.MAP_EXIT_HEIGHTS =
{
	arena = 
	{
		up = 128,
		left = 0,
		right = 0,
		down = 0,
	},

	baby_ogres = 
	{
		up = 128,
		left = 0,
		right = 0,
		down = 0,
	},

	desert_oasis = 
	{
		up = 128,
		left = 0,
		right = 0,
		down = 0,
	},

	morty_transition = 
	{
		up = 384,
		left = 384,
		right = 0,
		down = 0,
	},

	penguins_transition =
	{
		up = 0,
		left = 0,
		right = 0,
		down = 0,
	},

	floating_chamber_boss2 =
	{
		up = 256,
		left = 256,
		right = 256,
		down = 256,
	},

	radiant_stadium = 
	{
		up = 0,
		left = 0,
		right = 0,
		down = 0,
	},

	test_height_diff =
	{
		up = 256,
		left = 0,
		right = 128,
		down = 0,
	},

	empty_cavern =
	{
		up = 256,
		left = 0,
		right = 128,
		down = 0,
	},

	empty_beach =
	{
		up = 256,
		left = 0,
		right = 128,
		down = 0,
	},

	hellfire_canyon = 
	{
		up = 128,
		left = 128,
		right = 128,
		down = 128,			
	},

	temple_garden_traps = 
	{
		up = 0,
		left = 0,
		right = 0,
		down = 0,			
	},

	mausoleum = 
	{
		up = 256,
		left = 256,
		right = 0,
		down = 0,			
	},
}

-- If you want a particular unit to have a different model scale, put it here
_G.ENCOUNTER_PREVIEW_SCALES =
{
	npc_dota_pinecone_champion = 1.2,
	npc_dota_creature_hellbear = 1.2,
	npc_dota_creature_spectral_tusk_mage = 1.5,
	npc_dota_creature_baby_ogre_tank = 1.3,
	npc_dota_creature_large_ogre_seal = 0.8,
	npc_dota_creature_dazzle = 1.35,
	npc_dota_creature_huge_broodmother = 1.6,
	npc_dota_creature_morphling_big = 1.4,
	npc_dota_creature_zealot_scarab = 1.4,
	npc_dota_creature_ogre_tank = 1.8,
	npc_dota_sled_penguin = 3.5,
	npc_dota_creature_storegga = 1.5,
	npc_dota_creature_mirana = 1.25,
	npc_dota_creature_puck = 1.2,
	npc_dota_creature_alchemist = 1.2,
	npc_dota_creature_pudge = 1.2,
	npc_dota_creature_warlock = 1.4,
	npc_dota_creature_dragon_knight = 1.2,
	npc_dota_creature_pudge_miniboss = 1.3,
	npc_dota_creature_bomber = 1.5,
	npc_dota_creature_bonus_chicken = 2.8,
	npc_dota_creature_temple_guardian = 1.2,
	npc_dota_boss_void_spirit = 1.2,
	npc_aghsfort_creature_tornado_harpy = 1.8,
	npc_dota_creature_drow_ranger_miniboss = 1.5,
	npc_dota_creature_dark_seer = 1.5,
	npc_dota_creature_shroom_giant = 1.6,
	npc_dota_creature_troll_warlord_ranged = 1.5,
	npc_dota_creature_bonus_greevil = 2.0,
	npc_dota_creature_naga_siren_boss = 1.5,
	npc_dota_creature_legion_commander = 1.25,
	npc_dota_shop_keeper = 1.5,
	npc_dota_spike_trap_ward = 0.5,
	npc_dota_creature_huskar = 1.5,
}

-- For debugging at the moment, a fixed layout of rooms
_G.USE_ENCOUNTER_FIXED_LAYOUT = false

_G.ENCOUNTER_FIXED_LAYOUT =
{
	a1_1a = "encounter_starting_room",
	a1_2a = "encounter_quill_beasts",
	a1_2b = "encounter_enraged_hellbears",
	a1_3a = "encounter_bombers",
	a1_3b = "encounter_jungle_fire_maze", --"encounter_tusk_skeletons",
	a1_3c = "encounter_wildwings",
	a1_4a = "encounter_wave_blasters",
	a1_4b = "encounter_baby_ogres",
	a1_4c = "encounter_morphlings",
	a1_4d = "encounter_zealot_scarabs",
	a1_5a = "encounter_warlocks",
	a1_5b = "encounter_ogre_seals",
	a1_boss = "encounter_boss_timbersaw",
	
	a2_transition = "encounter_morty_transition",

	a2_1a = "encounter_pudge_miniboss",
	a2_2a = "encounter_mirana",
	a2_2b = "encounter_mirana",
	a2_3a = "encounter_spectres",
	a2_3b = "encounter_rock_golems",
	a2_3c = "encounter_spectres",
	a2_4a = "encounter_dire_siege",
	a2_4b = "encounter_big_ogres",
	a2_4c = "encounter_hellfire_canyon",
	a2_4d = "encounter_big_ogres",
	a2_5a = "encounter_test_immediate_victory",
	a2_5b = "encounter_test_immediate_victory",
	a2_boss = "encounter_storegga",

	a3_1a = "encounter_bonus_chicken",
	a3_2a = "encounter_alchemist",
	a3_2b = "encounter_enraged_wildwings",
	a3_3a = "encounter_elemental_tiny",
	a3_3b = "encounter_bandits",
	a3_3c = "encounter_bomb_squad",
	a3_4a = "encounter_broodmothers",
	a3_4b = "encounter_kunkka_tide",
	a3_4c = "encounter_broodmothers",
	a3_4d = "encounter_kunkka_tide",
	a3_5a = "encounter_test_immediate_victory",
	a3_5b = "encounter_test_immediate_victory",
	a3_boss = "encounter_rhyzik",
}