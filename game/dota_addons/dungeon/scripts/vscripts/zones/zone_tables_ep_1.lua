_G.ZonesDefinition =
{
	--------------------------------------------------
	-- START
	--------------------------------------------------
	{
		szName = "start",
		nZoneID = 1,
		Type = ZONE_TYPE_EXPLORE,
		bNoLeaderboard = true,
		MaxZoneXP = 0,
		MaxZoneGold = 0,
		Quests =
		{
	
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_injured_contact",
				szSpawnerName = "forest_injured_contact",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},					
		},
		Squads = {},
	},

	--------------------------------------------------
	-- FOREST
	--------------------------------------------------
	{
		szName = "forest",
		nZoneID = 2,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 4700,  -- Level 1-4
		MaxZoneGold = 5500,
		szTeleportEntityName = "start_zone_forest",
		nArtifactCoinReward = 5,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					540,
					390,
					180,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "kill_hellbears",
				Values =
				{
					8,
					12,
					16,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "reach_the_camp",
				szQuestType = "Explore",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "forest",
					},			
				},
				Completion = 
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "forest_holdout",
				},
			},
			{
				szQuestName = "kill_hellbears",
				szQuestType = "Kill",
				RewardXP = 200,
				RewardGold = 200,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "forest",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_hellbear",	
					szZoneName = "forest",		
				},
				bOptional = true,
				nCompleteLimit = 16,
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_journal_note_01",
				szSpawnerName = "forest_journal_note_01",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_journal_note_02",
				szSpawnerName = "forest_journal_note_02",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},			
		},		
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 30.0,
			flMaxSpawnInterval = 45.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"forest_attackers",
			},
			ChasingSquads =
			{
				"Chasing_A",
				"Chasing_B",
			},
		},
		Squads = 
		{
			Fixed = 
			{
				Fixed_Start =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = RandomInt( 3, 5 ),
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_fixed_start",
				},
				Fixed_End =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 7,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_fixed_end",
				},
			},
			Random = 
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 6,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 4,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_5 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_6 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 6,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_7 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_8 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 4,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_9 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 4,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
				Random_10 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_dire_hound",
							nCount = RandomInt( 10, 14 ),
						},
						{
							szNPCName = "npc_dota_creature_dire_hound_boss",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_attackers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_dire_hound",
							nCount = RandomInt( 6, 8 ),
						},
						{
							szNPCName = "npc_dota_creature_dire_hound_boss",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "forest_attackers",
				},
			}
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.4,
				szSpawnerName = "f_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 1,
				nMinGold = 250,
				nMaxGold = 450,
				Items =
				{
					"item_quelling_blade",
					"item_wind_lace",
					"item_blight_stone",
					"item_ring_of_protection",
					"item_sobi_mask",
					"item_stout_shield",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "forest_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 100,
				nMaxGold = 200,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- FOREST HOLDOUT
	--------------------------------------------------
	{
		szName = "forest_holdout",
		nZoneID = 3,
		Type = ZONE_TYPE_HOLDOUT,
		MaxZoneXP = 6000,  -- Level 4-6.5
		MaxZoneGold = 5500,
		vTeleportPos = Vector( -10363, -7004, 256 ),
		nArtifactCoinReward = 10,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					540,
					420,
					300,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "speak_to_the_chief",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_QUEST_COMPLETE,
						szQuestName = "reach_the_camp",
					},		
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_forest_camp_chief",
					nDialogLine = 2,
				},
			},
			{
				szQuestName = "learn_about_holdout",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_forest_camp_chief",
						nDialogLine = 2,
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
					szNPCName = "npc_dota_forest_camp_chief",
					nDialogLine = 3,	
				},
			},
			{
				szQuestName = "defend_the_camp",
				szQuestType = "Holdout",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
						szNPCName = "npc_dota_forest_camp_chief",
						nDialogLine = 3,
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_lycan_boss",	
				},
			},

			{
				szQuestName = "speak_to_chief_holdout_complete",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_QUEST_COMPLETE,
						szQuestName = "defend_the_camp",
					},			
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_forest_camp_chief",
					nDialogLine = 7,
				},
				bOptional = true,
			},
		},

		VIPs =
		{
			{
				szVIPName = "npc_dota_forest_camp_chief",
				szSpawnerName = "forest_holdout_spawner_chief_vip",
				nCount = 1,
				Activity = ACT_DOTA_SHARPEN_WEAPON,
			},
		},

		Neutrals =
		{
			{
				szNPCName = "npc_dota_forest_camp_melee_creep_1",
				szSpawnerName = "forest_holdout_spawner_melee_creep_1",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_forest_camp_melee_creep_2",
				szSpawnerName = "forest_holdout_spawner_melee_creep_2",
				nCount = 1,
				Activity = ACT_DOTA_SHARPEN_WEAPON,
			},
			{
				szNPCName = "npc_dota_forest_camp_melee_creep_3",
				szSpawnerName = "forest_holdout_spawner_melee_creep_3",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_forest_camp_melee_creep_4",
				szSpawnerName = "forest_holdout_spawner_melee_creep_4",
				nCount = 1,
				Activity = ACT_DOTA_IDLE_IMPATIENT,
			},
			{
				szNPCName = "npc_dota_forest_camp_melee_creep_5",
				szSpawnerName = "forest_holdout_spawner_melee_creep_5",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_journal_note_05",
				szSpawnerName = "forest_holdout_journal_note_05",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
		},
		
		Holdout =
		{
			StartQuest =
			{
				szQuestName = "defend_the_camp",
				bOnCompleted = false,
			},
			nVIPDeathsAllowed = 0,
			Spawners =
			{
				--[[
				{
					szSpawnerName = "forest_holdout_spawner_a",
					szWaypointName = "forest_holdout_path_a1",
				},

				{
					szSpawnerName = "forest_holdout_spawner_b",
					szWaypointName = "forest_holdout_path_b1",
				},

				{
					szSpawnerName = "forest_holdout_spawner_c",
					szWaypointName = "forest_holdout_path_c1",
				},
				]]
			},
			Waves =
			{
				-- Wave 1
				{
					flDuration = 50.0,
					flSpawnInterval = 10.0,
					NPCs =
					{
						-- A path
						DireHound_a =
						{
							szSpawnerName = "forest_holdout_spawner_a",
							szWaypointName = "forest_holdout_path_a1",
							szNPCName = "npc_dota_creature_dire_hound",
							nCount = RandomInt( 5, 7 ),
						},
						DireHoundBoss_a =
						{
							szSpawnerName = "forest_holdout_spawner_a",
							szWaypointName = "forest_holdout_path_a1",
							szNPCName = "npc_dota_creature_dire_hound_boss",
							nCount = 1,
						},

						-- B path
						SmallHellbear_a =
						{
							szSpawnerName = "forest_holdout_spawner_b",
							szWaypointName = "forest_holdout_path_b1",
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = RandomInt( 3, 5 ),
						},
						Hellbear_a =
						{
							szSpawnerName = "forest_holdout_spawner_b",
							szWaypointName = "forest_holdout_path_b1",
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 1,
						},

						-- C path
						DireHound_c =
						{
							szSpawnerName = "forest_holdout_spawner_c",
							szWaypointName = "forest_holdout_path_c1",
							szNPCName = "npc_dota_creature_dire_hound",
							nCount = RandomInt( 5, 7 ),
						},
						DireHoundBoss_c =
						{
							szSpawnerName = "forest_holdout_spawner_c",
							szWaypointName = "forest_holdout_path_c1",
							szNPCName = "npc_dota_creature_dire_hound_boss",
							nCount = 1,
						},
					},
				},

				-- Wave 2
				{
					flDuration = 40.0,
					flSpawnInterval = 10.0,
					NPCs =
					{
						-- A path
						SmallHellbear_a =
						{
							szSpawnerName = "forest_holdout_spawner_a",
							szWaypointName = "forest_holdout_path_a1",
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = RandomInt( 4, 6 ),
						},
						Hellbear_a =
						{
							szSpawnerName = "forest_holdout_spawner_a",
							szWaypointName = "forest_holdout_path_a1",
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 2,
						},
						Werewolf_a =
						{
							szSpawnerName = "forest_holdout_spawner_a",
							szWaypointName = "forest_holdout_path_a1",
							szNPCName = "npc_dota_creature_werewolf",
							nCount = 1,
						},

						-- B path
						DireHound_b =
						{
							szSpawnerName = "forest_holdout_spawner_b",
							szWaypointName = "forest_holdout_path_b1",
							szNPCName = "npc_dota_creature_dire_hound",
							nCount = RandomInt( 6, 8 ),
						},
						Werewolf_b =
						{
							szSpawnerName = "forest_holdout_spawner_b",
							szWaypointName = "forest_holdout_path_b1",
							szNPCName = "npc_dota_creature_werewolf",
							nCount = 1,
						},

						-- C path
						SmallHellbear_c =
						{
							szSpawnerName = "forest_holdout_spawner_c",
							szWaypointName = "forest_holdout_path_c1",
							szNPCName = "npc_dota_creature_small_hellbear",
							nCount = RandomInt( 4, 6 ),
						},
						Hellbear_c =
						{
							szSpawnerName = "forest_holdout_spawner_c",
							szWaypointName = "forest_holdout_path_c1",
							szNPCName = "npc_dota_creature_hellbear",
							nCount = 2,
						},
						Werewolf_c =
						{
							szSpawnerName = "forest_holdout_spawner_c",
							szWaypointName = "forest_holdout_path_c1",
							szNPCName = "npc_dota_creature_werewolf",
							nCount = 1,
						},
					},
				},

				-- Wave 3
				{
					flDuration = 22.0,
					flSpawnInterval = 1.0,
					NPCs =
					{
						-- Lycan
						LycanBoss =
						{
							szSpawnerName = "forest_holdout_spawner_b",
							szWaypointName = "forest_holdout_path_b1",
							szNPCName = "npc_dota_creature_lycan_boss",
							nCount = 1,
							nMaxSpawnCount = 1,
							bBoss = true,
							flDelay = 25,
						},
					},
				},
			},
		},

		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "fh_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 2,
				nMinGold = 400,
				nMaxGold = 600,
				Items =
				{
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_chainmail",
					"item_gloves",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "forest_holdout_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 150,
				nMaxGold = 250,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},

	},

	--------------------------------------------------
	-- DEATH MAZE
	--------------------------------------------------
	{
		szName = "darkforest_death_maze",
		nZoneID = 4,
		Type = ZONE_TYPE_EXPLORE,
		MaxZoneXP = 2000,
		MaxZoneGold = 1650,
		szTeleportEntityName = "forest_holdout_zone_darkforest_death_maze",
		nArtifactCoinReward = 15,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					420,
					330,
					210,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "navigate_death_maze",
				szQuestType = "Explore",
				RewardXP = 2000,
				RewardGold = 1100,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "darkforest_death_maze",
					},
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_forest_camp_chief",
						nDialogLine = 7,
					},	
					
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_KEY_ITEM_RECEIVED,
					szZoneName = "darkforest_death_maze",
					szItemName = "item_orb_of_passage",
				},
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_journal_note_03",
				szSpawnerName = "death_maze_journal_note_03",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_creature_invoker",
				szSpawnerName = "darkforest_death_maze_invoker",
				nCount = 1,
			},
		},				
		Squads = 
		{
			Random =
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_5 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_6 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 6,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_7 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 7,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_8 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_9 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_small_ghost",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
				Random_10 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ghost",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "death_maze_random",
				},
			},
		},
		Environment = {},
		Chests =
		{
			--TreasureChest_A =
			{
				fSpawnChance = 0.5,
				szSpawnerName = "dm_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 500,
				nMaxGold = 800,
				Items =
				{
					"item_cloak",
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_chainmail",
					"item_gloves",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed =
			{
				fSpawnChance = 1.0,
				szSpawnerName = "dm_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 500,
				nMaxGold = 800,
				Items =
				{
					"item_cloak",
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_chainmail",
					"item_gloves",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChestInvoker
			{
				fSpawnChance = 0,
				szSpawnerName = "dm_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 1,
				nMaxGold = 1,
				fItemChance = 0.85,
				Items =
				{
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_poor_mans_shield",
					"item_poor_mans_shield",
					"item_poor_mans_shield",
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_robe",
					"item_robe",
					"item_robe",
					"item_robe",
					"item_robe",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_chainmail",
					"item_chainmail",
					"item_chainmail",
					"item_chainmail",
					"item_chainmail",
					"item_gloves",
					"item_gloves",
					"item_gloves",
					"item_gloves",
					"item_gloves",
					"item_hood_of_defiance",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_refresher",
					"item_reaver",
					"item_hyperstone",
					"item_pers",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
				},
				fRelicChance = 0.04,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "death_maze_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 200,
				nMaxGold = 300,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- FOREST RESCUE
	--------------------------------------------------
	{
		szName = "darkforest_rescue",
		nZoneID = 5,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 6000,
		MaxZoneGold = 5500,
		--szTeleportEntityName = "forest_holdout_zone_darkforest_rescue",
		vTeleportPos = Vector( -9408, -256, 256 ),
		nArtifactCoinReward = 20,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					600,
					420,
					300,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "rescue_soldiers",
				Values =
				{
					4,
					8,
					11,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "rescue_soldiers",
				szQuestType = "Rescue",
				RewardXP = 250,
				RewardGold = 150,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "darkforest_rescue",
					},
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_forest_camp_chief",
						nDialogLine = 7,
					},	
					
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_radiant_soldier",
					szZoneName = "darkforest_rescue",
					nDialogLine = 1			
				},
				bOptional = true,
				nCompleteLimit = 11,
			},
			{
				szQuestName = "rescue_the_captain",
				szQuestType = "Rescue",
				RewardXP = 700,
				RewardGold = 500,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "darkforest_rescue",
					},
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_forest_camp_chief",
						nDialogLine = 7,
					},	
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_radiant_captain",
					szZoneName = "darkforest_rescue",
					nDialogLine = 1
				},
			},
			
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_journal_note_04",
				szSpawnerName = "darkforest_rescue_journal_note_04",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_01",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_02",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_03",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_04",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_05",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_06",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_07",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_08",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_09",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_10",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_rescue_cage",
				szSpawnerName = "darkforest_rescue_cage_11",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
		},						
		Survival = 
		{
			nSquadsPerSpawn = 1,
			flMinSpawnInterval = 90.0,
			flMaxSpawnInterval = 120.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"darkforest_rescue_attackers",
			},
			ChasingSquads =
			{
				"Chasing_A",
				"Chasing_B",
				"Chasing_C",
			},
		},
		VIPs =
		{
			{
				szVIPName = "npc_dota_radiant_captain",
				szSpawnerName = "rescue_imprisoned_captain_spawner",
				nCount = 1,
				bRequired = true,
				Activity = ACT_DOTA_RADIANT_CREEP_HAMMER,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_01",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_02",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_03",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_04",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_05",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_06",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_07",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_08",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_09",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_10",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_radiant_soldier",
				szSpawnerName = "rescue_imprisoned_soldier_spawner_11",
				nCount = 1,
			},
		},

		Squads = 
		{
			Fixed = 
			{
				OgreTanks_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_ogres_a",
				},
				OgreTanks_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_ogre_tanks_b",
				},
				OgreTanks_D =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_ogre_tanks_d",
				},
				OgreTanks_Bridge =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 64,
					szSpawnerName = "darkforest_rescue_bridge",
				},
				OgreTankBoss =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank_boss",
							nCount = 1,
							bBoss = true,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "darkforest_rescue_ogre_tank_boss",
				},
				OgreSeers =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_seer",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "darkforest_rescue_ogre_magi_for_boss",
				},
			},
			Random = 
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_5 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_6 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_7 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_8 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
				Random_9 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_attackers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_attackers",
				},
				Chasing_C =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_ogre_tank",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_ogre_magi",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_rescue_attackers",
				},
			}
		},

		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "dfr_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 600,
				nMaxGold = 800,
				Items =
				{
					"item_cloak",
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_chainmail",
					"item_gloves",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "dfr_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 600,
				nMaxGold = 800,
				Items =
				{
					"item_cloak",
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_chainmail",
					"item_gloves",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "darkforest_rescue_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 250,
				nMaxGold = 350,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- DARKFOREST PASS
	--------------------------------------------------
	{
		szName = "darkforest_pass",
		nZoneID = 6,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 7000,
		MaxZoneGold = 6600,
		--szTeleportEntityName = "forest_holdout_zone_darkforest_pass",
		vTeleportPos = Vector( 960, -11424, 384 ),
		nArtifactCoinReward = 25,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					720,
					540,
					540,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "kill_spider_eggs",
				Values =
				{
					35,
					50,
					65,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "kill_spider_boss",
				Values =
				{
					0,
					0,
					1,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "find_entrance_to_the_underground",
				szQuestType = "Explore",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_forest_camp_chief",
						nDialogLine = 6,
					},	
				},
				Completion = 
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "darkforest_pass",
				},
			},
			{
				szQuestName = "find_underground_temple",
				szQuestType = "Explore",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "darkforest_pass",
					},
				},
				Completion = 
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "underground_temple",
				},
			},
			{
				szQuestName = "kill_spider_eggs",
				szQuestType = "Kill",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "darkforest_pass",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_spider_sack",			
				},
				RewardXP = 1000,
				RewardGold = 1000,
				bOptional = true,
				nCompleteLimit = 65,
			},
			{
				szQuestName = "kill_spider_boss",
				szQuestType = "Kill",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "darkforest_pass",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_creature_spider_boss",			
				},
				bOptional = true,
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_journal_note_06",
				szSpawnerName = "darkforest_pass_journal_note_06",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_journal_note_07",
				szSpawnerName = "darkforest_pass_journal_note_07",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},			
		},								
		Survival = 
		{
			nSquadsPerSpawn = 1,
			flMinSpawnInterval = 30.0,
			flMaxSpawnInterval = 60.0,
			flSpawnIntervalChange = 15.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"darkforest_pass_attackers",
			},
			ChasingSquads =
			{
				"Chasing_A",
				"Chasing_B",
				"Chasing_C",
			},
		},
		VIPs =
		{
			{
				szVIPName = "npc_dota_creature_friendly_ogre_tank",
				szSpawnerName = "darkforest_pass_friendly_ogre",
				nCount = 1,
			},
			--[[
			{
				szVIPName = "npc_dota_creature_friendly_ogre_tank_webtrapped",
				szSpawnerName = "darkforest_pass_friendly_ogre",
				nCount = 1,
			},
			]]
		},		
		Squads = 
		{
			Fixed =
			{
				Spiders_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_small",
							nCount = 6,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_fixed_a",
				},
				Spiders_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_small",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_fixed_b",
				},
				Web =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "darkforest_pass_web",
				},
				SpiderSacks =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = RandomInt( 8, 12 ),
						},
					},
					nMaxSpawnDistance = 64,
					szSpawnerName = "darkforest_pass_spider_sacks",
				},
				SpiderBoss =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_boss",
							nCount = 1,
							bBoss = true,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "darkforest_pass_spiderboss",
					bUseSpawnerFaceAngle = true,
				},
			},
			Random =
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 6,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 4,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_5 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_6 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_7 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_8 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 9,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_9 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_small",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
				Random_10 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_spider_sack",
							nCount = 7,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_spider_web",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_kidnap_spider",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_random",
				},
			},			
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_small",
							nCount = 14,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_attackers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_small",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_attackers",
				},
				Chasing_C =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spider_small",
							nCount = 12,
						},
						{
							szNPCName = "npc_dota_creature_spider_medium",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "darkforest_pass_attackers",
				},
			}
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "dfp_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 4,
				nMinGold = 800,
				nMaxGold = 1100,
				Items =
				{
					"item_quarterstaff",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "dfp_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 4,
				nMinGold = 800,
				nMaxGold = 1100,
				Items =
				{
					"item_quarterstaff",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_tome_of_knowledge",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "darkforest_pass_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 300,
				nMaxGold = 400,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- UNDERGROUND TEMPLE
	--------------------------------------------------
	{
		szName = "underground_temple",
		nZoneID = 7,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 7000,
		MaxZoneGold = 6600,
		szTeleportEntityName = "darkforest_pass_zone_underground_temple",
		--vTeleportPos = Vector( 1691, -11634, 768 ),
		nArtifactCoinReward = 30,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					840,
					600,
					420,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "find_hidden_treasures",
				Values =
				{
					3,
					5,
					6,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "navigate_underground_temple",
				szQuestType = "Explore",
				RewardXP = 1000,
				RewardGold = 0,
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "underground_temple",
					},
					
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "desert_start",
					
				},
			},
			{
				szQuestName = "find_hidden_treasures",
				szQuestType = "Explore",
				RewardXP = 0,
				RewardGold = 0,
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_TREASURE_OPENED,
						szZoneName = "underground_temple",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_TREASURE_OPENED,
					szZoneName = "underground_temple",				
				},
				bOptional = true,
				nCompleteLimit = 6,
			},
		},
		Survival = 
		{
			nSquadsPerSpawn = 1,
			flMinSpawnInterval = 60.0,
			flMaxSpawnInterval = 75.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"underground_temple_attackers",
			},
			ChasingSquads =
			{
				"Chasing_A",
				"Chasing_B",
				"Chasing_C",
				"Chasing_D",
			},
		},
		Squads =
		{
			Fixed =
			{
			},
			Random =
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 13,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 8,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 6,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_5 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 9,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_6 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_7 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_8 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 9,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_9 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 13,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_10 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 9,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
				Random_11 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 8,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 12,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_attackers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 8,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_attackers",
				},
				Chasing_C =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_attackers",
				},
				Chasing_D =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_bat_spitter",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_bat",
							nCount = 6,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "underground_temple_attackers",
				},
			}
		},
		Environment = {},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "ut_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1000,
				nMaxGold = 1300,
				Items =
				{
					"item_quarterstaff",
					"item_broadsword",
					"item_javelin",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
				},
				fItemChance = 0.2,
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "ut_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1000,
				nMaxGold = 1300,
				Items =
				{
					"item_quarterstaff",
					"item_broadsword",
					"item_javelin",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
				},
				fItemChance = 0.2,
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "underground_temple_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 350,
				nMaxGold = 450,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "underground_temple_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 350,
				nMaxGold = 450,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- DESERT START
	--------------------------------------------------
	{
		szName = "desert_start",
		nZoneID = 8,
		Type = ZONE_TYPE_HOLDOUT,
		MaxZoneXP = 10000,
		MaxZoneGold = 7700,
		--szTeleportEntityName = "underground_temple_zone_desert_start",
		vTeleportPos = Vector( 11694, -5418, 512 ),
		nArtifactCoinReward = 35,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					540,
					300,
					180,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "learn_about_babyback",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "desert_start",
					},			
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_friendly_bristleback_son",
					nDialogLine = 2,
				},
			},
			{
				szQuestName = "start_escort",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_friendly_bristleback_son",
						nDialogLine = 2,
					},		
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
					szNPCName = "npc_dota_friendly_bristleback_son",
					nDialogLine = 3,
				},
			},
			{
				szQuestName = "escort_babyback_to_desert_town",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
						szNPCName = "npc_dota_friendly_bristleback_son",
						nDialogLine = 3,
					},
					
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "desert_town",
				},
			},
		},
		Neutrals = 
		{
			{
				szNPCName = "npc_dota_journal_note_08",
				szSpawnerName = "desert_start_journal_note_08",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},		
			{
				szNPCName = "npc_dota_temple_wisp",
				szSpawnerName = "temple_hall_temple_wisp",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},					
		},			
		VIPs =
		{
			{
				szVIPName = "npc_dota_friendly_bristleback_son",
				szSpawnerName = "desert_start_babyback_spawner",
				nCount = 1,
			},
		},
		Holdout =
		{
			StartQuest =
			{
				szQuestName = "escort_babyback_to_desert_town",
				bOnCompleted = false,
			},
			nVIPDeathsAllowed = 0,
			Spawners =
			{
			},
			Waves =
			{
				-- Wave 1
				{
					flDuration = 21.0,
					flSpawnInterval = 7.1, -- guard against possible extra group bug
					NPCs =
					{
						Wave1_Bandit1 =
						{
							szSpawnerName = "desert_start_spawner_1b",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 5,
						},
						Wave1_Bandit2 =
						{
							szSpawnerName = "desert_start_spawner_2",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 5,
						},
						Wave1_BanditCaptain =
						{
							szSpawnerName = "desert_start_spawner_2",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
					},
				},
				-- Wave 1b
				{
					flDuration = 14.0,
					flSpawnInterval = 7.1, -- guard against possible extra group bug
					NPCs =
					{
						Wave1_Bandit1 =
						{
							szSpawnerName = "desert_start_spawner_1b",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 3,
						},
						Wave1_Bandit2 =
						{
							szSpawnerName = "desert_start_spawner_2",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 3,
						},
						Wave1_BanditCaptain =
						{
							szSpawnerName = "desert_start_spawner_2",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
						Wave2_BanditArcher1 =
						{
							szSpawnerName = "desert_start_spawner_2",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_archer",
							nCount = 1,
							bDontSetGoalEntity = true,
						},
					},
				},
				-- Wave 2
				{
					flDuration = 14.0,
					flSpawnInterval = 7.1, -- guard against possible extra group bug
					NPCs =
					{
						-- A path
						Wave2_Bandit =
						{
							szSpawnerName = "desert_start_spawner_3",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 4,
						},
						Wave2_BanditCaptain =
						{
							szSpawnerName = "desert_start_spawner_4",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
						Wave2_BanditArcher1 =
						{
							szSpawnerName = "desert_start_spawner_2",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_archer",
							nCount = 1,
							bDontSetGoalEntity = true,
						},
					},
				},
				-- Wave 2b
				{
					flDuration = 7.0,
					flSpawnInterval = 7.1, -- guard against possible extra group bug
					NPCs =
					{
						-- A path
						Wave2b_Bandit =
						{
							szSpawnerName = "desert_start_spawner_3",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 4,
						},
						Wave2b_BanditCaptain =
						{
							szSpawnerName = "desert_start_spawner_4",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
						Wave2b_BanditArcher1 =
						{
							szSpawnerName = "desert_start_spawner_3",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_archer",
							nCount = 1,
							bDontSetGoalEntity = true,
						},
					},
				},
				-- Wave 3
				{
					flDuration = 7.0,
					flSpawnInterval = 7.1, -- guard against possible extra group bug
					NPCs =
					{
						-- A path
						Wave3_Bandit1 =
						{
							szSpawnerName = "desert_start_spawner_4",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 3,
						},
						Wave3_Captain =
						{
							szSpawnerName = "desert_start_spawner_4",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
						Wave3_Bandit2 =
						{
							szSpawnerName = "desert_start_spawner_5",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 2,
						},
						Wave3_BanditArcher1 =
						{
							szSpawnerName = "desert_start_spawner_5",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_archer",
							nCount = 1,
							bDontSetGoalEntity = true,
						},
					},
				},
				-- Wave 4
				{
					flDuration = 12.0,
					flSpawnInterval = 6.1, -- guard against possible extra group bug
					NPCs =
					{
						-- A path
						Wave4_Bandit1 =
						{
							szSpawnerName = "desert_start_spawner_5",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 3,
						},
						Wave4_Captain1 =
						{
							szSpawnerName = "desert_start_spawner_7",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
						Wave4_Bandit2 =
						{
							szSpawnerName = "desert_start_spawner_7",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 2,
						},
						Wave4_BanditArcher1 =
						{
							szSpawnerName = "desert_start_spawner_4",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_archer",
							nCount = 1,
							bDontSetGoalEntity = true,
						},
					},
				},
				-- Wave 5
				{
					flDuration = 6.0,
					flSpawnInterval = 6.1, -- guard against possible extra group bug
					NPCs =
					{
						-- A path
						Wave5_Bandit1 =
						{
							szSpawnerName = "desert_start_spawner_7",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 2,
						},
						Wave5_Captain1 =
						{
							szSpawnerName = "desert_start_spawner_5",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_captain",
							nCount = 1,
						},
						Wave5_Bandit2 =
						{
							szSpawnerName = "desert_start_spawner_5",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit",
							nCount = 2,
						},
						Wave5_BanditArcher1 =
						{
							szSpawnerName = "desert_start_spawner_7",
							szWaypointName = "npc_dota_friendly_bristleback_son",
							szNPCName = "npc_dota_creature_bandit_archer",
							nCount = 1,
							bDontSetGoalEntity = true,
						},
					},
				},
			},
		},
		Squads = 
		{
			Fixed =
			{
			},
			Random = 
			{			
			},	
			Chasing =
			{
			},
		},
		Environment = {},
		Chests =
		{
			--TreasureChest
			{
				fSpawnChance = 0.5,
				szSpawnerName = "desert_start_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 6,
				nMinGold = 1200,
				nMaxGold = 1500,
				Items =
				{
					"item_quarterstaff",
					"item_broadsword",
					"item_javelin",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
				},
				fItemChance = 0.4,
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_start_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 6,
				nMinGold = 1200,
				nMaxGold = 1500,
				Items =
				{
					"item_cheese",
					--"item_firework_mine",
					--"item_slippers_of_halcyon",
					--"item_arcane_boots2",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_start_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 400,
				nMaxGold = 500,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_start_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 400,
				nMaxGold = 500,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- DESERT TOWN
	--------------------------------------------------
	{
		szName = "desert_town",
		nZoneID = 9,
		Type = ZONE_TYPE_EXPLORE,
		MaxZoneXP = 0,
		MaxZoneGold = 0,
		bNoLeaderboard = true,
		szTeleportEntityName = "desert_start_zone_desert_town",
		Quests = 
		{
			
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_desert_townfolk_1",
				szSpawnerName = "spawner_desert_townfolk_1",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_desert_townfolk_2",
				szSpawnerName = "spawner_desert_townfolk_2",
				nCount = 1,
				Activity = ACT_DOTA_SHARPEN_WEAPON,
			},
			{
				szNPCName = "npc_dota_desert_townfolk_3",
				szSpawnerName = "spawner_desert_townfolk_3",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_desert_townfolk_4",
				szSpawnerName = "spawner_desert_townfolk_4",
				szWaypointName = "desert_town_path_1",
				nCount = 1,
				Activity = ACT_DOTA_IDLE_IMPATIENT,
			},
			{
				szNPCName = "npc_dota_desert_townfolk_5",
				szSpawnerName = "spawner_desert_townfolk_5",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_desert_townfolk_6",
				szSpawnerName = "spawner_desert_townfolk_6",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_desert_townfolk_7",
				szSpawnerName = "spawner_desert_townfolk_7",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_bristleback_grandpa",
				szSpawnerName = "spawner_desert_town_bristleback_grandpa",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
		},		
		Squads = 
		{
			Fixed = 
			{
			},
			Random =
			{
			},
		},
		
		Environment = {},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "desert_town_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 7,
				nMinGold = 1400,
				nMaxGold = 1700,
				Items =
				{
					"item_cloak",
					"item_stout_shield",
					"item_quelling_blade",
					"item_wind_lace",
					"item_sobi_mask",
					"item_ring_of_protection",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_town_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 450,
				nMaxGold = 550,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_town_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 450,
				nMaxGold = 550,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Rare Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_town_rare_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 500,
				nMaxGold = 600,
				fGoldChance = 0.0,
				CommonItems =
				{
					"item_cheese",
				},
				fCommonItemChance = 0.9,
				RareItems =
				{
					"item_dagon_3",
				},
				fRareItemChance = 0.1,
				--[[
				szTraps =
				{
					"trap_dagon",
				},
				nTrapLevel = 7,
				]]
			},
		},
	},

	--------------------------------------------------
	-- DESERT EXPANSE
	--------------------------------------------------
	{
		szName = "desert_expanse",
		nZoneID = 10,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 13000,
		MaxZoneGold = 11000,
		szTeleportEntityName = "desert_town_zone_desert_expanse",
		nArtifactCoinReward = 40,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					840,
					600,
					420,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "kill_giant_burrowers",
				Values =
				{
					4,
					6,
					8,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "kill_centaur_warlords",
				szQuestType = "Kill",
				RewardXP = 1200,
				RewardGold = 1200,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "desert_expanse",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_creature_centaur_warlord",
				},
				nCompleteLimit = 4,
			},
			{
				szQuestName = "kill_giant_burrowers",
				szQuestType = "Kill",
				RewardXP = 800,
				RewardGold = 800,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "desert_expanse",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_creature_giant_burrower",
				},
				bOptional = true,
				nCompleteLimit = 8,
			},
			{
				szQuestName = "reach_desert_outpost",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_QUEST_COMPLETE,
						szQuestName = "kill_centaur_warlords",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "desert_outpost",
				},
			},
		},
		Neutrals = 
		{
			{
				szNPCName = "npc_dota_journal_note_09",
				szSpawnerName = "desert_expanse_journal_note_09",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_journal_note_10",
				szSpawnerName = "desert_expanse_journal_note_10",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_creature_invoker",
				szSpawnerName = "desert_expanse_invoker",
				nCount = 1,
			},
		},	
		VIPs =
		{
			{
				szVIPName = "npc_dota_friendly_bristleback",
				szSpawnerName = "desert_expanse_bristleback",
				nCount = 1,
			},
		},				
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 60.0,
			flMaxSpawnInterval = 80.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"desert_expanse_attackers",
			},
			ChasingSquads =
			{
				"Chasing_A",
				"Chasing_B",
				"Chasing_C",
			},
		},
		Squads = 
		{
			Fixed = 
			{
				Camp_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_warlord",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_centaur_shaman",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_camp1",
				},
				Camp_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_warlord",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_centaur_shaman",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_camp2",
				},
				Camp_3 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_warlord",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_centaur_shaman",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_camp3",
				},
				Camp_4 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_warlord",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_centaur_shaman",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_camp4",
				},
				--[[
				DevTest_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_living_treasure",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "desert_expanse_dev_test",
				},
				]]
			},
			Random =
			{
				-- No random variance in these giant burrower groups currently.  There are 7 desert_expanse_random ents placed in map.
				Random_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_3 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_4 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_5 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_6 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_7 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
				Random_8 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_giant_burrower",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 512,
					szSpawnerName = "desert_expanse_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_scout",
							nCount = 11,
						},
						{
							szNPCName = "npc_dota_creature_centaur_dunerunner",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_attackers",
				},
				Chasing_B =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_scout",
							nCount = 12,
						},
						{
							szNPCName = "npc_dota_creature_centaur_dunerunner",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_attackers",
				},
				Chasing_C =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_centaur_scout",
							nCount = 7,
						},
						{
							szNPCName = "npc_dota_creature_centaur_dunerunner",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_expanse_attackers",
				},
			},
		},
		
		Environment = {},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "desert_expanse_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 7,
				nMinGold = 1600,
				nMaxGold = 1900,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_expanse_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 7,
				nMinGold = 1600,
				nMaxGold = 1900,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--LivingTreasure
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_expanse_living_treasure_guaranteed",
				szNPCName = "npc_dota_creature_living_treasure",
				nMaxSpawnDistance = 0,
				nMinGold = 0,
				nMaxGold = 0,
				Items =
				{
				},
			},
			--TreasureChestInvoker
			{
				fSpawnChance = 0,
				szSpawnerName = "dm_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 10,
				nMinGold = 1,
				nMaxGold = 1,
				fItemChance = 0.85,
				Items =
				{
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_branches",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_clarity",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_tango_single",
					"item_poor_mans_shield",
					"item_poor_mans_shield",
					"item_poor_mans_shield",
					"item_poor_mans_shield",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_blades_of_attack",
					"item_robe",
					"item_robe",
					"item_robe",
					"item_robe",
					"item_robe",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_boots_of_elves",
					"item_chainmail",
					"item_chainmail",
					"item_chainmail",
					"item_chainmail",
					"item_chainmail",
					"item_gloves",
					"item_gloves",
					"item_gloves",
					"item_gloves",
					"item_gloves",
					"item_hood_of_defiance",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_refresher",
					"item_reaver",
					"item_hyperstone",
					"item_pers",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
				},
				fRelicChance = 0.04,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_expanse_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 500,
				nMaxGold = 600,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_expanse_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 500,
				nMaxGold = 600,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- DESERT OUTPOST
	--------------------------------------------------
	{
		szName = "desert_outpost",
		nZoneID = 11,
		Type = ZONE_TYPE_EXPLORE,
		MaxZoneXP = 0,
		MaxZoneGold = 0,
		bNoLeaderboard = true,
		szTeleportEntityName = "desert_expanse_zone_desert_outpost",
		Quests = 
		{
		},
		VIPs =
		{
		},
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 60.0,
			flMaxSpawnInterval = 60.0,
			flSpawnIntervalChange = 0.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
			},
			ChasingSquads =
			{
			},
		},
		Squads = 
		{	
			Fixed =
			{

			},
			Random =
			{

			},
		},
		Environment = {},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "desert_outpost_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 8,
				nMinGold = 1700,
				nMaxGold = 2000,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_outpost_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 8,
				nMinGold = 1700,
				nMaxGold = 2000,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_outpost_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 550,
				nMaxGold = 650,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_outpost_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 550,
				nMaxGold = 650,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- DESERT CHASM
	--------------------------------------------------
	{
		szName = "desert_chasm",
		nZoneID = 12,
		Type = ZONE_TYPE_ASSAULT,
		MaxZoneXP = 14000,
		MaxZoneGold = 13200,
		szTeleportEntityName = "desert_outpost_zone_desert_chasm",
		nArtifactCoinReward = 45,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					240,
					150,
					90,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "speak_to_the_captain",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_friendly_bristleback",
						nDialogLine = 2,
					},		
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_radiant_captain",
					nDialogLine = 2,
				},
			},
			{
				szQuestName = "learn_about_assault",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_radiant_captain",
						nDialogLine = 2,
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
					szNPCName = "npc_dota_radiant_captain",
					nDialogLine = 3,	
				},
			},
			{
				szQuestName = "assault_the_desert_fortress",
				szQuestType = "Holdout",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
						szNPCName = "npc_dota_radiant_captain",
						nDialogLine = 3,	
					},			
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_dire_assault_captain",
				},
			},
			{
				szQuestName = "kill_the_dire_captains",
				szQuestType = "Holdout",
				szCompletionLogicRelay = "desert_chasm_exit_relay",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
						szNPCName = "npc_dota_radiant_captain",
						nDialogLine = 3,	
					},			
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_dire_assault_captain",
				},
				nCompleteLimit = 3,
			},
		},
		Assault = 
		{
			StartQuest =
			{
				szQuestName = "assault_the_desert_fortress",
				bOnCompleted = false,
			},
			nAttackerTeam = DOTA_TEAM_GOODGUYS,
			nDefenderTeam = DOTA_TEAM_BADGUYS,

			nMaxRescuedAttackersPerWave = 20,
			szRescuedAttackerTypes =
			{
				"npc_dota_creature_friendly_ogre_tank",
				"npc_dota_radiant_captain",
				"npc_dota_radiant_soldier",
			},
			szRescuedAttackerStartEntity = "desert_outpost_teleport",
			szRescuedAttackerWaypoint = "good_assault_1",

			nMaxDefenders = 65,

			Attackers =
			{
				{
					flSpawnInterval = 20.0,
					NPCs =
					{
						-- A path
						MeleeCreeps =
						{
							szSpawnerName = "desert_outpost_melee_creeps",
							szWaypointName = "good_assault_1",
							szNPCName = "npc_dota_assault_good_melee_creep",
							nCount = 3,
						},
						RangedCreeps =
						{
							szSpawnerName = "desert_outpost_ranged_creeps",
							szWaypointName = "good_assault_1",
							szNPCName = "npc_dota_assault_good_ranged_creep",
							nCount = 1,
						},
					},
				},
			},
			Defenders =
			{
				nSquadsPerSpawn = 5,
				flSpawnInterval = 14.0,
				bDontRepeatSquads = true,
				ChasingSpawners =
				{
					"desert_chasm_squad_rax_1",
					"desert_chasm_squad_rax_2",
					"desert_chasm_squad_rax_3",
					"desert_chasm_squad_rax_4",
					"desert_chasm_squad_rax_5",
				},
				ChasingSquads =
				{
					"Rax_1",
					"Rax_2",
					"Rax_3",
					"Rax_4",
					"Rax_5",
				},
			},
		},
		Squads = 
		{	
			Fixed =
			{
				Entrance_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_entrance_1",
				},
				Entrance_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_ranged_creep",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_creature_catapult",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_entrance_2",
				},
				Entrance2_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_catapult",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_entrance2_1",
				},
				Entrance2_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_ranged_creep",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_catapult",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_entrance2_2",
				},
				Entrance2_3 =
				{
					NPCs =
					{

						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_assault_bad_ranged_creep",
							nCount = 2,
						},
						{
							szNPCName = "npc_dota_creature_catapult",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_entrance2_3",
				},
				Entrance3_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_catapult",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "desert_chasm_squad_entrance3_1",
				},
				Entrance3_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_catapult",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "desert_chasm_squad_entrance3_2",
				},
				Megas =
				{
					NPCs =
					{

						{
							szNPCName = "npc_dota_dire_assault_captain",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_megas",
				},
			},
			Random =
			{

			},
			Chasing =
			{
				Rax_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_rax_1",
				},
				Rax_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_assault_bad_ranged_creep",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_rax_2",
				},
				Rax_3 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 6,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_rax_3",
				},
				Rax_4 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_assault_bad_ranged_creep",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_rax_4",
				},
				Rax_5 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_assault_bad_melee_creep",
							nCount = 6,
						},
						{
							szNPCName = "npc_dota_assault_bad_ranged_creep",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "desert_chasm_squad_rax_5",
				},
			},
		},
		Environment = {},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "desert_chasm_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 9,
				nMinGold = 1700,
				nMaxGold = 2000,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_chasm_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 9,
				nMinGold = 1700,
				nMaxGold = 2000,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_chasm_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 600,
				nMaxGold = 700,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_chasm_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 600,
				nMaxGold = 700,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},

	--------------------------------------------------
	-- DESERT FORTRESS
	--------------------------------------------------
	{
		szName = "desert_fortress",
		nZoneID = 13,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 99999,
		MaxZoneGold = 99999,
		szTeleportEntityName = "desert_chasm_zone_desert_fortress",
		nArtifactCoinReward = 100,
		bVictoryOnComplete = true,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					660,
					420,
					240,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_DEATHS,
				Values =
				{
					5,
					2,
					0,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "kill_sand_king",
				szQuestType = "Explore",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "desert_fortress",
					},			
				},
				Completion = 
				{
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_creature_sand_king",
				},
			},
		},
		Neutrals = 
		{
			{
				szNPCName = "npc_dota_journal_note_11",
				szSpawnerName = "desert_fortress_journal_note_11",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},		
		},							
		Survival = 
		{
			nSquadsPerSpawn = 1,
			flMinSpawnInterval = 60.0,
			flMaxSpawnInterval = 60.0,
			flSpawnIntervalChange = 0.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{

			},
			ChasingSquads =
			{
			},
		},
		Squads = 
		{	
			Fixed =
			{
				SandKing =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_sand_king",
							nCount = 1,
							bBoss = true,
						},
					},
					nMaxSpawnDistance = 200,
					szSpawnerName = "sand_king_boss",
				},
			},
			Random =
			{

			},
			Chasing =
			{

			},
		},
		Environment = {},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "desert_fortress_treasure_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 10,
				nMinGold = 1900,
				nMaxGold = 2200,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_fortress_treasure_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 10,
				nMinGold = 1900,
				nMaxGold = 2200,
				Items =
				{
					"item_oblivion_staff",
					"item_talisman_of_evasion",
					"item_hyperstone",
					"item_aether_lens",
					"item_ultimate_orb",
				},
				Relics =
				{
					"item_creed_of_omniscience",
					"item_oblivions_locket",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
		},
		Breakables =
		{
			-- Crate
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_fortress_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 650,
				nMaxGold = 750,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "desert_fortress_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 650,
				nMaxGold = 750,
				fGoldChance = 0.11,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.07,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
	},
}
