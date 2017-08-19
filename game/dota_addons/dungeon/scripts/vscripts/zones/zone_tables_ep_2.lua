_G.ZonesDefinition =
{
	--------------------------------------------------
	-- EP 2 START
	--------------------------------------------------
	{
		szName = "ep_2_start",
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
			
		},
		VIPs =
		{
			{
				szVIPName = "npc_dota_temple_wisp",
				szSpawnerName = "temple_hall_temple_wisp",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},			
		
		},
		Squads = {},
	},

	--------------------------------------------------
	-- TUNDRA
	--------------------------------------------------
	{
		szName = "tundra",
		nZoneID = 2,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 5000,
		MaxZoneGold = 4000,
		szTeleportEntityName = "ep_2_start_zone_tundra",
		nArtifactCoinReward = 5,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					600,
					450,
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
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "kill_frostbitten_shamans",
				Values =
				{
					10,
					20,
					30,
				},
			},
		},
		Quests =
		{
			{
				szQuestName = "reach_ice_lake",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "tundra",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "ice_lake",
				},
			},
			{
				szQuestName = "kill_frostbitten_shamans",
				szQuestType = "Kill",
				RewardXP = 50,
				RewardGold = 50,
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "tundra",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_frostbitten_ranged",	
					szZoneName = "tundra",
				},
				bOptional = true,
				nCompleteLimit = 30,
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_journal_note_12",
				szSpawnerName = "tundra_journal_note_01",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_journal_note_13",
				szSpawnerName = "tundra_journal_note_02",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},			
		},
		Survival =
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 45.0,
			flMaxSpawnInterval = 60.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"tundra_chasers",
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
				Entry_Spawner =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 2, 3 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 256,
					szSpawnerName = "tundra_shaman_zone_intro_spawner",
				},
				RitualShamans_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
							bUseSpawnerFaceAngle = true,
							Activities =
							{
								ACT_DO_NOT_DISTURB,
								--ACT_DOTA_VICTORY,
							}
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "tundra_shaman_ritualist_01",
				},
				RitualShamans_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
							bUseSpawnerFaceAngle = true,
							Activities =
							{
								--ACT_DO_NOT_DISTURB,
								ACT_DOTA_VICTORY,
							}
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "tundra_shaman_ritualist_02",
				},
				Giant_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_large_frostbitten_melee",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "tundra_large_frostbitten",
				},
				End =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_large_frostbitten_melee",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "tundra_end",
				},
			},
			Random = 
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_5 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_6 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_7 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 6, 9 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_8 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_9 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_10 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_11 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_12 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_13 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_14 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 3, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_15 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 2, 4 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = RandomInt( 0, 1 ),
						},
						{
							szNPCName = "npc_dota_creature_large_frostbitten_melee",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_16 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 2, 4 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = RandomInt( 0, 1 ),
						},
						{
							szNPCName = "npc_dota_creature_large_frostbitten_melee",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
				Random_17 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 2, 4 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = RandomInt( 0, 1 ),
						},
						{
							szNPCName = "npc_dota_creature_large_frostbitten_melee",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "tundra_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_large_frostbitten_melee",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "tundra_chasers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_frostbitten_melee",
							nCount = RandomInt( 5, 6 ),
						},
						{
							szNPCName = "npc_dota_creature_frostbitten_ranged",
							nCount = RandomInt( 1, 2 ),
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "tundra_chasers",
				},
			}
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "tundra_chest",
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
				fItemChance = 0.3,
				Items =
				{
					"item_ring_of_protection",
					"item_circlet",
					"item_circlet", -- x2
					"item_quelling_blade",
					"item_stout_shield",
					"item_wind_lace",
					"item_orb_of_venom",
					"item_blight_stone",
					"item_recipe_headdress",
					"item_ring_of_regen",
					"item_sobi_mask",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "tundra_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				nTrapLevel = 1,
				nMinGold = 250,
				nMaxGold = 450,
				fItemChance = 0.3,
				Items =
				{
					"item_ring_of_protection",
					"item_circlet",
					"item_circlet", -- x2
					"item_quelling_blade",
					"item_stout_shield",
					"item_wind_lace",
					"item_orb_of_venom",
					"item_blight_stone",
					"item_recipe_headdress",
					"item_ring_of_regen",
					"item_sobi_mask",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "tundra_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 140,
				nMaxGold = 170,
				fGoldChance = 0.15,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.25,
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
	-- ICE LAKE
	--------------------------------------------------
	{
		szName = "ice_lake",
		nZoneID = 3,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 6000,
		MaxZoneGold = 4500,
		szTeleportEntityName = "tundra_zone_ice_lake",
		nArtifactCoinReward = 10,
		StarCriteria =
		{
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
				szQuestName = "kill_big_bears",
				Values =
				{
					1,
					2,
					3,
				},
			},
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "save_penguins",
				Values =
				{
					10,
					20,
					30,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "kill_big_bears",
				szQuestType = "Kill",
				RewardXP = 600,
				RewardGold = 600,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_elon_tusk",
						nDialogLine = 1,
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName = "npc_dota_creature_big_bear",
				},
				bOptional = true,
				nCompleteLimit = 3,
			},
			{
				szQuestName = "reach_aerie",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_QUEST_COMPLETE,
						szQuestName = "kill_big_bears",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "aerie",
				},
			},
			{
				szQuestName = "save_penguins",
				szQuestType = "Explore",
				RewardXP = 500,
				RewardGold = 500,
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_penguin",
						nDialogLine = 1
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_penguin",
					nDialogLine = 2
				},
				bOptional = true,
				nCompleteLimit = 30,
			},
		},
		VIPs =
		{
			{
				szVIPName = "npc_dota_elon_tusk",
				szSpawnerName = "ice_lake_quest_giver",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin1",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin2",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin3",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin4",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin5",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin6",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin7",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin8",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin9",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin10",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin11",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin12",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin13",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin14",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin15",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin16",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin17",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin18",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin19",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin20",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin21",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin22",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin23",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin24",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin25",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin26",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin27",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin28",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin29",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_penguin",
				szSpawnerName = "ice_lake_penguin30",
				nCount = 1,
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_journal_note_14",
				szSpawnerName = "ice_lake_journal_note_03",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},
			{
				szNPCName = "npc_dota_journal_note_15",
				szSpawnerName = "ice_lake_journal_note_04",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_journal_note_16",
				szSpawnerName = "ice_lake_journal_note_05",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},					
		},		
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 75.0,
			flMaxSpawnInterval = 95.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"ice_lake_chasers",
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
				Fixed_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_medium_bear",
							nCount = RandomInt( 4, 5 ),
						},
						{
							szNPCName = "npc_dota_creature_big_bear",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "ice_lake_bear_camp",
				},
				Fixed_2 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_medium_bear",
							nCount = RandomInt( 2, 3 ),
						}
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "ice_lake_fixed_smallbears",
				},
				OgreSeals_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_ogre_seal",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 640,
					szSpawnerName = "ice_lake_ogre_seals",
				},
				SmallBears_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_small_bear",
							nCount = RandomInt( 4, 6 ),
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "ice_lake_small_bears",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_small_bear",
							nCount = RandomInt( 10, 14 ),
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "ice_lake_chasers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_medium_bear",
							nCount = RandomInt( 4, 6 ),
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "ice_lake_chasers",
				},
				Chasing_C =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_ogre_seal_chaser",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "ice_lake_chasers",
				},
			}
		},
		Chests =
		{
			--TreasureChest_A =
			{
				fSpawnChance = 0.5,
				szSpawnerName = "ice_lake_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 400,
				nMaxGold = 700,
				Items =
				{
					"item_tome_of_knowledge",
					"item_sobi_mask",
					"item_ring_of_regen",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_null_talisman",
					"item_wraith_band",
					"item_bracer",
					"item_poor_mans_shield",
					"item_gloves",
					"item_ring_of_basilius",
					"item_recipe_veil_of_discord",
					"item_chainmail",
					"item_cloak",
					"item_recipe_crimson_guard",
					"item_recipe_aether_lens",
					"item_recipe_cyclone",
					"item_recipe_maelstrom",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed =
			{
				fSpawnChance = 1.0,
				szSpawnerName = "ice_lake_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 3,
				nMinGold = 400,
				nMaxGold = 700,
				Items =
				{
					"item_tome_of_knowledge",
					"item_sobi_mask",
					"item_ring_of_regen",
					"item_blades_of_attack",
					"item_robe",
					"item_belt_of_strength",
					"item_boots_of_elves",
					"item_null_talisman",
					"item_wraith_band",
					"item_bracer",
					"item_poor_mans_shield",
					"item_gloves",
					"item_ring_of_basilius",
					"item_recipe_veil_of_discord",
					"item_chainmail",
					"item_cloak",
					"item_recipe_crimson_guard",
					"item_recipe_aether_lens",
					"item_recipe_cyclone",
					"item_recipe_maelstrom",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "ice_lake_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 200,
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
					"item_greater_salve",
					"item_greater_clarity",
				},
				fCommonItemChance = 0.40,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
		AlliedStructures =
		{
			-- Campfire
			{
				fSpawnChance = 1.0,
				szSpawnerName = "ice_lake_campfire",
				szNPCName = "npc_dota_campfire",
				nMaxSpawnDistance = 0,
			},
		},
	},

	--------------------------------------------------
	-- AERIE
	--------------------------------------------------
	{
		szName = "aerie",
		nZoneID = 4,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 1500,
		MaxZoneGold = 800,
		szTeleportEntityName = "ice_lake_zone_aerie",
		nArtifactCoinReward = 15,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					420,
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
				szQuestName = "kill_ice_boss",
				szQuestType = "Kill",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "aerie",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_ice_boss",			
				},
				RewardXP = 500,
				RewardGold = 500,
			},
		},
		Neutrals =
		{
		},		
		Survival = 
		{
		},
		Squads = 
		{
			Fixed = 
			{
				Boss_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_ice_boss",
							nCount = 1,
							bBoss = true,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "aerie_ice_boss",
				},
				Eggiwegs =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_ice_boss_egg",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "aerie_ice_boss_egg",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
			}
		},
		Chests =
		{
		},
		Breakables =
		{
		},
	},

	--------------------------------------------------
	-- CLIFFTOP
	--------------------------------------------------
	{
		szName = "clifftop",
		nZoneID = 5,
		Type = ZONE_TYPE_EXPLORE,
		MaxZoneXP = 0,
		MaxZoneGold = 0,
		bNoLeaderboard = true,
		szTeleportEntityName = "aerie_zone_clifftop",
		StarCriteria =
		{
		},
		Quests = 
		{
		},
		VIPs =
		{
			{
				szVIPName = "npc_dota_sled_penguin",
				szSpawnerName = "clifftop_penguin1",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_sled_penguin",
				szSpawnerName = "clifftop_penguin2",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_sled_penguin",
				szSpawnerName = "clifftop_penguin3",
				nCount = 1,
			},
			{
				szVIPName = "npc_dota_sled_penguin",
				szSpawnerName = "clifftop_penguin4",
				nCount = 1,
			},
		},
		Neutrals =
		{
		},
		Survival = 
		{
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
			}
		},
		Chests =
		{
		},
		Breakables =
		{
		},
	},

	--------------------------------------------------
	-- TUSKTOWN
	--------------------------------------------------
	{
		szName = "tusktown",
		nZoneID = 6,
		Type = ZONE_TYPE_EXPLORE,
		MaxZoneXP = 0,
		MaxZoneGold = 0,
		bNoLeaderboard = true,
		szTeleportEntityName = "clifftop_zone_tusktown",
		StarCriteria =
		{
		},
		Quests = 
		{
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_tusktown_villager",
				szSpawnerName = "tusktown_villager_01",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_child",
				szSpawnerName = "tusktown_villager_02",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_villager_2",
				szSpawnerName = "tusktown_villager_03",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_villager_3",
				szSpawnerName = "tusktown_villager_04",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_villager_4",
				szSpawnerName = "tusktown_villager_05",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_villager_5",
				szSpawnerName = "tusktown_villager_06",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_villager_6",
				szSpawnerName = "tusktown_villager_07",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_villager_7",
				szSpawnerName = "tusktown_villager_08",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			{
				szNPCName = "npc_dota_tusktown_seer",
				szSpawnerName = "tusktown_villager_09",
				szWaypointName = "tusk_town_path_1",
				nCount = 1,
				Activity = ACT_DOTA_IDLE_IMPATIENT,
			},			
			{
				szNPCName = "npc_dota_chef",
				szSpawnerName = "tusktown_chef_01",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},	
			{
				szNPCName = "npc_dota_creature_snow_leopard",
				szSpawnerName = "tusktown_pet_01",
				nCount = 1,
				Activity = ACT_DOTA_IDLE_RARE,
			},	
			{
				szNPCName = "npc_dota_journal_note_17",
				szSpawnerName = "tusktown_journal_note_06",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_journal_note_18",
				szSpawnerName = "tusktown_journal_note_07",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},				
			
		},
		Survival =
		{
		},
		Squads =
		{
		},
		Chests =
		{
		},
		Breakables =
		{
		},
		AlliedStructures =
		{
			-- Campfire
			{
				fSpawnChance = 1.0,
				szSpawnerName = "tusktown_campfire",
				szNPCName = "npc_dota_campfire",
				nMaxSpawnDistance = 0,
			},
		},
	},

	--------------------------------------------------
	-- PLATEAU
	--------------------------------------------------
	{
		szName = "plateau",
		nZoneID = 7,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 8000,
		MaxZoneGold = 5000,
		szTeleportEntityName = "tusktown_zone_plateau",
		nArtifactCoinReward = 15,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					600,
					480,
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
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "kill_ice_giants",
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
				szQuestName = "reach_crag",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "plateau",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "crag",
				},
			},
			{
				szQuestName = "kill_ice_giants",
				szQuestType = "Kill",
				RewardXP = 400,
				RewardGold = 400,
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "plateau",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_ice_giant",	
					szZoneName = "plateau",
				},
				bOptional = true,
				nCompleteLimit = 8,
			},
		},
		Neutrals =
		{
		},
		Survival =
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 50.0,
			flMaxSpawnInterval = 65.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"plateau_chasers",
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
				WeatherDummy =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_weather_dummy",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "plateau_weather_dummy",
				},
				IceGiant_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_ice_giant",
							nCount = 1,
							bUseSpawnerFaceAngle = true,
						},
						{
							szNPCName = "npc_dota_creature_small_yak",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "plateau_ice_giant",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_relict",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_large_relict",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "plateau_chasers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_relict",
							nCount = 9,
						},
						{
							szNPCName = "npc_dota_creature_large_relict",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "plateau_chasers",
				},
				Chasing_C =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_relict",
							nCount = 14,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "plateau_chasers",
				},
			}
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "plateau_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 4,
				nMinGold = 500,
				nMaxGold = 800,
				Items =
				{
					"item_tome_of_knowledge",
					"item_recipe_maelstrom",
					"item_headdress",
					"item_soul_ring",
					"item_buckler",
					"item_void_stone",
					"item_ring_of_health",
					"item_quarterstaff",
					"item_helm_of_iron_will",
					"item_recipe_mekansm",
					"item_energy_booster",
					"item_ring_of_aquila",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_vitality_booster",
					"item_point_booster",
					"item_recipe_dagon",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "plateau_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 4,
				nMinGold = 500,
				nMaxGold = 800,
				Items =
				{
					"item_tome_of_knowledge",
					"item_recipe_maelstrom",
					"item_headdress",
					"item_soul_ring",
					"item_buckler",
					"item_void_stone",
					"item_ring_of_health",
					"item_quarterstaff",
					"item_helm_of_iron_will",
					"item_recipe_mekansm",
					"item_energy_booster",
					"item_ring_of_aquila",
					"item_ogre_axe",
					"item_blade_of_alacrity",
					"item_staff_of_wizardry",
					"item_vitality_booster",
					"item_point_booster",
					"item_recipe_dagon",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "plateau_crate",
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
					"item_greater_salve",
					"item_greater_clarity",
				},
				fCommonItemChance = 0.40,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.02,
			},
		},
		AlliedStructures =
		{
			-- Campfire
			{
				fSpawnChance = 1.0,
				szSpawnerName = "plateau_campfire",
				szNPCName = "npc_dota_campfire",
				nMaxSpawnDistance = 0,
			},
		},
	},

	--------------------------------------------------
	-- CRAG
	--------------------------------------------------
	{
		szName = "crag",
		nZoneID = 8,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 3000,
		MaxZoneGold = 1000,
		szTeleportEntityName = "plateau_zone_crag",
		nArtifactCoinReward = 20,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					480,
					360,
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
				szQuestName = "kill_elder_tiny",
				szQuestType = "Kill",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "crag",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_elder_tiny",			
				},
				RewardXP = 500,
				RewardGold = 500,
			},
		},
		Neutrals =
		{	
			{
				szNPCName = "npc_dota_storegga_rock",
				szSpawnerName = "storegga_rock",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock2",
				szSpawnerName = "storegga_rock1",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock3",
				szSpawnerName = "storegga_rock2",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock2",
				szSpawnerName = "storegga_rock3",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock3",
				szSpawnerName = "storegga_rock4",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock",
				szSpawnerName = "storegga_rock5",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock",
				szSpawnerName = "storegga_rock6",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock2",
				szSpawnerName = "storegga_rock7",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock3",
				szSpawnerName = "storegga_rock8",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock3",
				szSpawnerName = "storegga_rock9",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock2",
				szSpawnerName = "storegga_rock10",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock3",
				szSpawnerName = "storegga_rock11",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock2",
				szSpawnerName = "storegga_rock12",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock2",
				szSpawnerName = "storegga_rock13",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_storegga_rock",
				szSpawnerName = "storegga_rock14",
				nCount = 1,
			},
		},
		Survival = 
		{
		},
		Squads = 
		{
			Fixed = 
			{
				Boss_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_elder_tiny",
							nCount = 1,
							bBoss = true,
							bUseSpawnerFaceAngle = true,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "crag_elder_tiny",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
			}
		},
		Chests =
		{
		},
		Breakables =
		{
		},
	},

	--------------------------------------------------
	-- CRYPT
	--------------------------------------------------
	{
		szName = "crypt",
		nZoneID = 9,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 15000,
		MaxZoneGold = 8500,
		szTeleportEntityName = "crag_zone_crypt",
		nArtifactCoinReward = 25,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					840,
					600,
					360,
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
				szQuestName = "escape_crypt",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "crypt",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "crypt_holdout",
				},
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_creature_invoker",
				szSpawnerName = "crypt_invoker",
				nCount = 1,
			},
			{
				szNPCName = "npc_dota_creature_wraith",
				szSpawnerName = "crypt_wraith",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
			
			{
				szNPCName = "npc_dota_creature_octopus",
				szSpawnerName = "crypt_holdout_octopus",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
		},
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 90.0,
			flMaxSpawnInterval = 120.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"crypt_chasers",
			},
			ChasingSquads =
			{
				"Chasing_A",
			},
		},
		Squads = 
		{
			Fixed = 
			{
				Undead_OgreSeal =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_undead_ogre_seal",
							nCount = 1,
							bUseSpawnerFaceAngle = true,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_ogre_seal",
				},
			},
			Random = 
			{
				Maze_Random_01 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 15,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_02 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_03 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_04 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 15,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_05 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_06 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_07 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_08 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Random_09 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_random",
				},
				Maze_Spectral_Random_01 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_spectral_random",
				},
				Maze_Spectral_Random_02 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_spectral_random",
				},
				Maze_Spectral_Random_03 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_spectral_random",
				},
				Maze_Spectral_Random_04 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_spectral_random",
				},
				Maze_Spectral_Random_05 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_spectral_random",
				},
				Maze_Spectral_Random_06 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_maze_spectral_random",
				},
				Middle_Random_01 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_02 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_03 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_04 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 15,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_05 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
						
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_06 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_07 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_08 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 5,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_09 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_10 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_11 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_12 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 10,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_13 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = RandomInt( 5, 8 ),
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_14 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
				Middle_Random_15 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_middle_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 10,
						},
						{
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_chasers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 10,
						},
						{
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_chasers",
				},
			},
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "crypt_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 700,
				nMaxGold = 1000,
				Items =
				{
					"item_void_stone",
					"item_ring_of_health",
					"item_quarterstaff",
					"item_recipe_mjollnir",
					"item_energy_booster",
					"item_vitality_booster",
					"item_point_booster",
					"item_broadsword",
					"item_recipe_dagon",
					"item_recipe_assault",
					"item_recipe_radiance",
					"item_claymore",
					"item_talisman_of_evasion",
					"item_javelin",
					"item_ghost",
					"item_mithril_hammer",
					"item_recipe_guardian_greaves",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "crypt_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 700,
				nMaxGold = 1000,
				Items =
				{
					"item_void_stone",
					"item_ring_of_health",
					"item_quarterstaff",
					"item_recipe_mjollnir",
					"item_energy_booster",
					"item_vitality_booster",
					"item_point_booster",
					"item_broadsword",
					"item_recipe_dagon",
					"item_recipe_assault",
					"item_recipe_radiance",
					"item_claymore",
					"item_talisman_of_evasion",
					"item_javelin",
					"item_ghost",
					"item_mithril_hammer",
					"item_recipe_guardian_greaves",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "crypt_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 300,
				nMaxGold = 400,
				fGoldChance = 0.06,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
					"item_greater_salve",
					"item_greater_clarity",
				},
				fCommonItemChance = 0.20,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.01,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "crypt_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 300,
				nMaxGold = 400,
				fGoldChance = 0.06,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.20,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.01,
			},
		},
		AlliedStructures =
		{
			-- Campfire
			{
				fSpawnChance = 1.0,
				szSpawnerName = "crypt_campfire",
				szNPCName = "npc_dota_campfire",
				nMaxSpawnDistance = 0,
			},
		},
	},

	--------------------------------------------------
	-- CRYPT HOLDOUT
	--------------------------------------------------
	{
		szName = "crypt_holdout",
		nZoneID = 10,
		Type = ZONE_TYPE_HOLDOUT,
		MaxZoneXP = 6500,
		MaxZoneGold = 3000,
		szTeleportEntityName = "crypt_zone_crypt_holdout",
		nArtifactCoinReward = 30,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					360,
					240,
					120,
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
				szQuestName = "speak_to_naga",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "crypt_holdout",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_DIALOG,
					szNPCName = "npc_dota_creature_naga",
					nDialogLine = 1,
				},
			},
			{
				szQuestName = "learn_about_crypt_holdout",
				szQuestType = "Speak",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG,
						szNPCName = "npc_dota_creature_naga",					
						nDialogLine = 3,
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
					szNPCName = "npc_dota_creature_naga",
					nDialogLine = 4,
				},
			},
			{
				szQuestName = "activate_door_switches",
				szQuestType = "Holdout",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
						szNPCName = "npc_dota_creature_naga",
						nDialogLine = 4,
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_CUSTOM_EVENT,
					szZoneName = "crypt_holdout",
					szEventName = "door_switch_completed",
				},
				nCompleteLimit = 4,
				RewardXP = 0,
				RewardGold = 0,
			},
			{
				szQuestName = "escape_crypt_holdout",
				szQuestType = "Holdout",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED,
						szNPCName = "npc_dota_creature_naga",
						nDialogLine = 4,
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "reefs_edge",
				},
				RewardXP = 3000,
				RewardGold = 2500,
			},
		},
		VIPs =
		{
			
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_creature_naga",
				szSpawnerName = "crypt_holdout_wisp",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
		},
		Holdout =
		{
			StartQuest =
			{
				szQuestName = "escape_crypt_holdout",
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
					flDuration = 26.0,
					flSpawnInterval = 13.0,
					NPCs =
					{
						-- SouthWest
						Skeletons_sw =
						{
							szSpawnerName = "crypt_holdout_spawner_sw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},		

						-- NorthWest
						Skeletons_nw =
						{
							szSpawnerName = "crypt_holdout_spawner_nw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 8,
						},
						MageSkeletons_nw =
						{
							szSpawnerName = "crypt_holdout_spawner_nw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},

						-- NorthEast path
						Skeletons_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 7,
						},
						Spectral_tusk_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
				},

				-- Wave 2
				{
					flDuration = 36.0,
					flSpawnInterval = 12.0,
					NPCs =
					{
						-- SouthWest
						Skeletons_sw =
						{
							szSpawnerName = "crypt_holdout_spawner_sw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						
						-- NorthWest
						Skeletons_nw =
						{
							szSpawnerName = "crypt_holdout_spawner_nw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
		
						TuskSkeletons_nw =
						{
							szSpawnerName = "crypt_holdout_spawner_nw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},

						-- NorthEast path
						Skeletons_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						MageSkeletons_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 1,
						},
						TuskSkeletons_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},
					},
				},
				-- Wave 3
				{
					flDuration = 40.0,
					flSpawnInterval = 10.0,
					NPCs =
					{
						-- SouthWest
						Skeletons_sw =
						{
							szSpawnerName = "crypt_holdout_spawner_sw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						

						-- NorthWest
						Skeletons_nw =
						{
							szSpawnerName = "crypt_holdout_spawner_nw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
		
						TuskSkeletons_nw =
						{
							szSpawnerName = "crypt_holdout_spawner_nw",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_spectral_tusk",
							nCount = 1,
						},

						-- NorthEast path
						Skeletons_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_tusk_skeleton",
							nCount = 12,
						},
						MageSkeletons_ne =
						{
							szSpawnerName = "crypt_holdout_spawner_ne",
							bTargetPlayers = true,
							nAcquireRadius = 3000,
							szNPCName = "npc_dota_creature_icy_tusk_skeleton",
							nCount = 2,
						},
						
					},
				},
			},
		},
		Squads = 
		{
			Fixed = 
			{
				VisionDummy =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_holdout_vision_dummy",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "crypt_holdout_vision_dummy",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
			},
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "crypt_holdout_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 800,
				nMaxGold = 1100,
				Items =
				{
					"item_quarterstaff",
					"item_recipe_mjollnir",
					"item_energy_booster",
					"item_vitality_booster",
					"item_point_booster",
					"item_broadsword",
					"item_recipe_dagon",
					"item_recipe_assault",
					"item_recipe_radiance",
					"item_claymore",
					"item_talisman_of_evasion",
					"item_javelin",
					"item_ghost",
					"item_mithril_hammer",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "crypt_holdout_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 800,
				nMaxGold = 1100,
				Items =
				{
					"item_quarterstaff",
					"item_recipe_mjollnir",
					"item_energy_booster",
					"item_vitality_booster",
					"item_point_booster",
					"item_broadsword",
					"item_recipe_dagon",
					"item_recipe_assault",
					"item_recipe_radiance",
					"item_claymore",
					"item_talisman_of_evasion",
					"item_javelin",
					"item_ghost",
					"item_mithril_hammer",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "crypt_holdout_crate",
				szNPCName = "npc_dota_crate",
				nMaxSpawnDistance = 0,
				nMinGold = 300,
				nMaxGold = 400,
				fGoldChance = 0.06,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.20,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.01,
			},
			-- Vase
			{
				fSpawnChance = 1.0,
				szSpawnerName = "crypt_holdout_vase",
				szNPCName = "npc_dota_vase",
				nMaxSpawnDistance = 0,
				nMinGold = 300,
				nMaxGold = 400,
				fGoldChance = 0.06,
				CommonItems =
				{
					"item_health_potion",
					"item_health_potion",
					"item_mana_potion",
					"item_mana_potion",
					"item_flask",
					"item_enchanted_mango",
				},
				fCommonItemChance = 0.20,
				RareItems =
				{
					"item_book_of_strength",
					"item_book_of_agility",
					"item_book_of_intelligence",
				},
				fRareItemChance = 0.01,
			},
		},
	},

	--------------------------------------------------
	-- REEF'S EDGE
	--------------------------------------------------
	{
		szName = "reefs_edge",
		nZoneID = 11,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 19000,
		MaxZoneGold = 13000,
		szTeleportEntityName = "crypt_holdout_zone_reefs_edge",
		nArtifactCoinReward = 35,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					360,
					240,
					120,
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
				szQuestName = "navigate_reefs_edge",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "reefs_edge",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "shoal",
				},
			},
		},
		Neutrals =
		{
		},
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 20.0,
			flMaxSpawnInterval = 40.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"reefs_edge_chasers",
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
				ReefCrawler =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_reef_crawler",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_reef_crawler",
				},
			},
			Random = 
			{
				ReefsEdge_Random_01 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_diregull",
							nCount = RandomInt( 16, 20 ),
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_random",
				},
				ReefsEdge_Random_02 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_diregull",
							nCount = RandomInt( 10, 12 ),
						},
						{
							szNPCName = "npc_dota_creature_reef_crawler",
							nCount = 4,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_random",
				},
				ReefsEdge_Random_03 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_reef_crawler",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_random",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_diregull",
							nCount = RandomInt( 16, 20 ),
						},

					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_random",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_diregull",
							nCount = RandomInt( 10, 12 ),
						},
						{
							szNPCName = "npc_dota_creature_reef_crawler",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_random",
				},
				Chasing_C =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_reef_crawler",
							nCount = 5,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "reefs_edge_random",
				},
			},
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "reefs_edge_chest",
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
					"item_energy_booster",
					"item_recipe_greater_crit",
					"item_vitality_booster",
					"item_point_booster",
					"item_recipe_dagon",
					"item_recipe_radiance",
					"item_broadsword",
					"item_talisman_of_evasion",
					"item_javelin",
					"item_ghost",
					"item_oblivion_staff",
					"item_recipe_refresher",
					"item_mask_of_madness",
					"item_vanguard",
					"item_lesser_crit",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "reefs_edge_chest_guaranteed",
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
					"item_energy_booster",
					"item_recipe_greater_crit",
					"item_vitality_booster",
					"item_point_booster",
					"item_recipe_dagon",
					"item_broadsword",
					"item_talisman_of_evasion",
					"item_javelin",
					"item_ghost",
					"item_oblivion_staff",
					"item_recipe_refresher",
					"item_mask_of_madness",
					"item_vanguard",
					"item_lesser_crit",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "reefs_edge_crate",
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
				fCommonItemChance = 0.40,
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
	-- SHOAL
	--------------------------------------------------
	{
		szName = "shoal",
		nZoneID = 12,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 6000,
		MaxZoneGold = 5000,
		szTeleportEntityName = "reefs_edge_zone_shoal",
		nArtifactCoinReward = 40,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					420,
					240,
					120,
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
				szQuestName = "kill_amoeba",
				szQuestType = "Kill",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "shoal",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_amoeba_boss",			
				},
				RewardXP = 0,
				RewardGold = 0,
				nCompleteLimit = 1,

			},
		},
		Neutrals =
		{
		},
		Survival = 
		{
		},
		Squads = 
		{
			Fixed = 
			{
				Boss_1 =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_amoeba_boss",
							nCount = 1,
							bBoss = true,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "amoeba_boss",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
			},
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "shoal_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1100,
				nMaxGold = 1400,
				Items =
				{
					"item_energy_booster",
					"item_vitality_booster",
					"item_point_booster",
					"item_broadsword",
					"item_claymore",
					"item_javelin",
					"item_mithril_hammer",
					"item_talisman_of_evasion",
					"item_ghost",
					"item_hyperstone",
					"item_lesser_crit",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "shoal_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1100,
				nMaxGold = 1400,
				Items =
				{
					"item_energy_booster",
					"item_vitality_booster",
					"item_point_booster",
					"item_broadsword",
					"item_claymore",
					"item_javelin",
					"item_mithril_hammer",
					"item_talisman_of_evasion",
					"item_ghost",
					"item_hyperstone",
					"item_lesser_crit",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "shoal_crate",
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
				fCommonItemChance = 0.40,
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
	-- DARK REEF A
	--------------------------------------------------
	{
		szName = "dark_reef_a",
		nZoneID = 13,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 0,
		MaxZoneGold = 0,
		bNoLeaderboard = true,
		szTeleportEntityName = "shoal_zone_dark_reef_a",
		StarCriteria =
		{

		},
		Quests = 
		{
			{
				szQuestName = "reach_dark_reef_b",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "dark_reef_a",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "dark_reef_b",
				},
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_creature_coral_furryfish",
				szSpawnerName = "dark_reef_a_fish",
				nCount = 1,
				Activity = ACT_DOTA_IDLE,
			},
		},
		Survival = 
		{
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
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "dark_reef_a_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1200,
				nMaxGold = 1500,
				Items =
				{
					"item_oblivion_staff",
					"item_broadsword",
					"item_platemail",
					"item_javelin",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
					"item_lesser_crit",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "dark_reef_a_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1200,
				nMaxGold = 1500,
				Items =
				{
					"item_oblivion_staff",
					"item_broadsword",
					"item_platemail",
					"item_javelin",
					"item_talisman_of_evasion",
					"item_vitality_booster",
					"item_energy_booster",
					"item_point_booster",
					"item_ghost",
					"item_lesser_crit",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "dark_reef_a_crate",
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
				fCommonItemChance = 0.40,
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
	-- DARK REEF B
	--------------------------------------------------
	{
		szName = "dark_reef_b",
		nZoneID = 14,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 22000,
		MaxZoneGold = 15000,
		szTeleportEntityName = "dark_reef_a_zone_dark_reef_b",
		nArtifactCoinReward = 45,
		StarCriteria =
		{
			{
				Type = ZONE_STAR_CRITERIA_TIME,
				Values =
				{
					600,
					360,
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
			{
				Type = ZONE_STAR_CRITERIA_QUEST_COMPLETE,
				szQuestName = "unlock_prison_cells",
				Values =
				{
					2,
					4,
					6,
				},
			},
		},
		Quests = 
		{
			{
				szQuestName = "unlock_prison_cells",
				szQuestType = "Explore",
				Activators = 
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "dark_reef_b",
					},				
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_CUSTOM_EVENT,
					szZoneName = "dark_reef_b",
					szEventName = "prison_cell_opened",
				},
				nCompleteLimit = 6,
				RewardXP = 0,
				RewardGold = 0,
			},
			{
				szQuestName = "find_siltbreaker",
				szQuestType = "Explore",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "dark_reef_b",
					},
				},
				Completion =
				{
					Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
					szZoneName = "silt_arena",
				},
			},
		},
		Neutrals =
		{
			{
				szNPCName = "npc_dota_warden_note_01",
				szSpawnerName = "prison_warden_note_01",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_02",
				szSpawnerName = "prison_warden_note_02",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_03",
				szSpawnerName = "prison_warden_note_03",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_04",
				szSpawnerName = "prison_warden_note_04",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_05",
				szSpawnerName = "prison_warden_note_05",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_06",
				szSpawnerName = "prison_warden_note_06",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_07",
				szSpawnerName = "prison_warden_note_07",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_08",
				szSpawnerName = "prison_warden_note_08",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_09",
				szSpawnerName = "prison_warden_note_09",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_10",
				szSpawnerName = "prison_warden_note_10",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
			{
				szNPCName = "npc_dota_warden_note_11",
				szSpawnerName = "prison_warden_note_11",
				nCount = 1,
				Activity = ACT_DOTA_LOOK_AROUND,
			},	
		},
		Survival = 
		{
			nSquadsPerSpawn = 2,
			flMinSpawnInterval = 60.0,
			flMaxSpawnInterval = 75.0,
			flSpawnIntervalChange = 5.0,
			bDontRepeatSquads = false,
			ChasingSpawners =
			{
				"dark_reef_b_gaoler",
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
				DarkReef_Gaoler =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_gaoler",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "dark_reef_b_gaoler",
				},
			},
			Random = 
			{
				Random_1 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_meranth_guard",
							nCount = 12,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "dark_reef_b_prisoners",
				},
				Random_2 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_meranth_guard",
							nCount = 3,
						},
						{
							szNPCName = "npc_dota_creature_prisoner_crab",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "dark_reef_b_prisoners",
				},
				Random_3 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_meranth_guard",
							nCount = 7,
						},
						{
							szNPCName = "npc_dota_creature_prisoner_crab",
							nCount = 1,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "dark_reef_b_prisoners",
				},
				Random_4 =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_prisoner_crab",
							nCount = 3,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "dark_reef_b_prisoners",
				},
			},
			Chasing =
			{
				Chasing_A =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_prisoner_crab",
							nCount = 2,
						},
					},
					nMaxSpawnDistance = nSQUADMEMBER_MAX_SPAWN_DIST,
					szSpawnerName = "dark_reef_b_chasers",
				},
				Chasing_B =
				{
					NPCs = 
					{
						{
							szNPCName = "npc_dota_creature_meranth_guard",
							nCount = 12,
						},
					},
					nMaxSpawnDistance = 300,
					szSpawnerName = "dark_reef_b_chasers",
				},
			},
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "dark_reef_b_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1400,
				nMaxGold = 1700,
				Items =
				{
					"item_cheese",
					"item_hyperstone",
					"item_ultimate_orb",
					"item_lesser_crit",
					"item_demon_edge",
					"item_invis_sword",
					"item_mystic_staff",
					"item_reaver",
					"item_eagle",
					"item_relic",
					"item_moon_shard",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "dark_reef_b_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 5,
				nMinGold = 1400,
				nMaxGold = 1700,
				Items =
				{
					"item_cheese",
					"item_hyperstone",
					"item_ultimate_orb",
					"item_lesser_crit",
					"item_demon_edge",
					"item_invis_sword",
					"item_mystic_staff",
					"item_reaver",
					"item_eagle",
					"item_relic",
					"item_moon_shard",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "dark_reef_b_crate",
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
				fCommonItemChance = 0.40,
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
	-- SILTBREAKER
	--------------------------------------------------
	{
		szName = "silt_arena",
		nZoneID = 15,
		Type = ZONE_TYPE_SURVIVAL,
		MaxZoneXP = 99999,
		MaxZoneGold = 99999,
		szTeleportEntityName = "dark_reef_b_zone_silt_arena",
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
				szQuestName = "kill_siltbreaker",
				szQuestType = "Kill",
				Activators =
				{
					{
						Type = QUEST_EVENT_ON_ZONE_ACTIVATE,
						szZoneName = "silt_arena",
					},
				},
				Completion =
				{	
					Type = QUEST_EVENT_ON_ENEMY_KILLED,
					szNPCName ="npc_dota_creature_siltbreaker",			
				},
				RewardXP = 2000,
				RewardGold = 2000,
			},
		},
		Neutrals =
		{
		},
		Survival =
		{
		},
		Squads =
		{
			Fixed = 
			{
				Siltbreaker =
				{
					NPCs =
					{
						{
							szNPCName = "npc_dota_creature_siltbreaker",
							nCount = 1,
							bBoss = true,
						},
					},
					nMaxSpawnDistance = 0,
					szSpawnerName = "siltbreaker_boss",
				},
			},
			Random = 
			{
			},
			Chasing =
			{
			},
		},
		Chests =
		{
			--TreasureChest_A
			{
				fSpawnChance = 0.5,
				szSpawnerName = "silt_arena_chest",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 10,
				nMinGold = 1200,
				nMaxGold = 1500,
				Items =
				{
					"item_cheese",
					"item_hyperstone",
					"item_ultimate_orb",
					"item_demon_edge",
					"item_mystic_staff",
					"item_reaver",
					"item_eagle",
					"item_relic",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
					"item_ambient_sorcery",
					"item_corrupting_blade",
					"item_life_rune",
				},
				fRelicChance = 0.02,
			},
			--TreasureChest_Guaranteed
			{
				fSpawnChance = 1.0,
				szSpawnerName = "silt_arena_chest_guaranteed",
				szNPCName = "npc_treasure_chest",
				nMaxSpawnDistance = 0,
				szTraps =
				{
					"creature_techies_land_mine",
					"trap_sun_strike",
				},
				nTrapLevel = 10,
				nMinGold = 1200,
				nMaxGold = 1500,
				Items =
				{
					"item_cheese",
					"item_hyperstone",
					"item_ultimate_orb",
					"item_demon_edge",
					"item_mystic_staff",
					"item_reaver",
					"item_eagle",
					"item_relic",
				},
				Relics =
				{
					"item_bear_cloak",
					"item_ogre_seal_totem",
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
				szSpawnerName = "silt_arena_crate",
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
				fCommonItemChance = 0.40,
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
