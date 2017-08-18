
if GetMapName() == "ep_2" or GetMapName() == "ep_2_alt" then
	_G.DialogDefinition =
	{
		npc_dota_temple_wisp =
		{
			{
				szText = "Dialog_Wisp_Ep2Start",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Wisp_Ep2Start_02",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true,
				Gesture = ACT_DOTA_CAPTURE,
			},
			{
				szText = "Dialog_Wisp_Ep2Start_03",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = false,
				Gesture = ACT_DOTA_LOADOUT,
			},
		},

		npc_dota_elon_tusk =
		{
			{
				szText = "Dialog_ElonTusk",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true,
				Gesture = ACT_DOTA_CAST_ABILITY_3,
			},
		},

		npc_dota_scared_villager =
		{
			{
				szText = "Dialog_ScaredVillager",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true,
				Gesture = ACT_DOTA_LOADOUT,
				bForceBreak = true,
			},
		},

		npc_dota_tusktown_seer =
		{
			{
				szText = "Dialog_TuskTown_Seer_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				bDialogStopsMovement = true,
				bForceBreak = true,
				Gesture = ACT_DOTA_IDLE_RARE,
			},
			{
				szText = "Dialog_TuskTown_Seer_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				bDialogStopsMovement = true,
				Gesture = ACT_DOTA_IDLE_RARE,
			},
			{
				szText = "Dialog_TuskTown_Seer_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				bDialogStopsMovement = true,
				bForceBreak = true,
				Gesture = ACT_DOTA_IDLE_RARE,
			},
			{
				szText = "Dialog_TuskTown_Seer_04",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				bDialogStopsMovement = true,
				bForceBreak = true,
				Gesture = ACT_DOTA_IDLE_RARE,
			},			
		},
		
		npc_dota_tusktown_villager =
		{
			{
				szText = "Dialog_TuskTown_Villager01_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				Gesture = ACT_DOTA_IDLE,
			},
		},	
		
		npc_dota_tusktown_villager_2 =
		{
			{
				szText = "Dialog_TuskTown_Villager02_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_TuskTown_Villager02_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				Gesture = ACT_DOTA_IDLE,
			},
		},		
		npc_dota_tusktown_villager_3 =
		{
			{
				szText = "Dialog_TuskTown_Villager03_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_TuskTown_Villager03_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_TuskTown_Villager03_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
		},		
		npc_dota_tusktown_villager_4 =
		{
			{
				szText = "Dialog_TuskTown_Villager04_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				Gesture = ACT_DOTA_IDLE,
			},
		},		
		npc_dota_tusktown_villager_5 =
		{
			{
				szText = "Dialog_TuskTown_Villager05_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_TuskTown_Villager05_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				Gesture = ACT_DOTA_IDLE,
			},
		},		
		npc_dota_tusktown_villager_6 =
		{
			{
				szText = "Dialog_TuskTown_Villager06_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_TuskTown_Villager06_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_TuskTown_Villager06_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_TuskTown_Villager06_04",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
		},		
		npc_dota_tusktown_villager_7 =
		{
			{
				szText = "Dialog_TuskTown_Villager07_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_TuskTown_Villager07_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_TuskTown_Villager07_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE,
			},
		},		

		npc_dota_tusktown_child =
		{
			{
				szText = "Dialog_TuskTown_Child_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_CAST_ABILITY_5,
			},
			{
				szText = "Dialog_TuskTown_Child_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				Gesture = ACT_DOTA_CAST_ABILITY_5,
			},
		},
		
		npc_dota_creature_snow_leopard =
		{
			{
				szText = "Dialog_TuskTown_leopold_01",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE_RARE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_TuskTown_leopold_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_IDLE_RARE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_TuskTown_leopold_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false,
				Gesture = ACT_DOTA_IDLE_RARE,
			},
		},
		
		npc_dota_chef =
		{
			{
				szText = "Dialog_TuskTown_Chef_01",
				flAdvanceTime = 20.0,
				bSendToAll = false,
				bAdvance = true,
				bSkipFacePlayer = true,
				Gesture = ACT_DOTA_IDLE_IMPATIENT,
			},
			{
				szText = "Dialog_TuskTown_Chef_02",
				flAdvanceTime = 20.0,
				bSendToAll = false,
				bAdvance = true,
				bSkipFacePlayer = true,
				Gesture = ACT_DOTA_IDLE_IMPATIENT,
			},
			{
				szText = "Dialog_TuskTown_Chef_03",
				flAdvanceTime = 20.0,
				bSendToAll = false,
				bAdvance = true,
				bSkipFacePlayer = true,
				Gesture = ACT_DOTA_IDLE_IMPATIENT,
			},
			{
				szText = "Dialog_TuskTown_Chef_04",
				flAdvanceTime = 20.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
				Gesture = ACT_DOTA_IDLE_IMPATIENT,
			},			
		},		

		npc_dota_creature_ice_boss =
		{
			{
				szText = "",
				Gesture = ACT_DOTA_VICTORY, 
				Sound = "winter_wyvern_winwyv_levelup_04",
				bSkipBossIntro = false,

				bSendToAll = true,
				bAdvance = true, 

				flAdvanceTime = 5.0,
			},
		},

		npc_dota_creature_elder_tiny =
		{
			{
				szText = "",
				Gesture = ACT_DOTA_SPAWN, 
				Sound = "tiny_tiny_respawn_06",
				bSkipBossIntro = false,

				bSendToAll = true,
				bAdvance = true, 

				flAdvanceTime = 5.0,
			},
		},

		npc_dota_creature_amoeba_boss =
		{
			{
				szText = "",
				Gesture = ACT_DOTA_IDLE_RARE, 
				Sound = "",
				bSkipBossIntro = false,

				bSendToAll = true,
				bAdvance = true, 

				flAdvanceTime = 5.0,
			},
		},

		npc_dota_creature_siltbreaker =
		{
			{
				szText = "",
				Gesture = ACT_DOTA_CAST_ABILITY_2, 
				Sound = SiltbreakerIntros[RandomInt( 1, #SiltbreakerIntros )],
				bSkipBossIntro = false,

				bSendToAll = true,
				bAdvance = true, 

				flAdvanceTime = 7.5,
			},
		},

		npc_dota_penguin =
		{
			{
				szText = "",
			--	Gesture = ACT_DOTA_CAST_ABILITY_2, 
				Sound = "Hero_Tusk.IceShards.Penguin",

				bSendToAll = false,
				bAdvance = false, 
				bSkipFacePlayer = true,

				flAdvanceTime = 5.0,
			},
			{
				szText = "",
			--	Gesture = ACT_DOTA_CAST_ABILITY_2, 
				Sound = "Hero_Tusk.IceShards.Penguin",

				bSendToAll = false,
				bAdvance = false, 
				bSkipFacePlayer = true,

				flAdvanceTime = 5.0,
			},
		},

		npc_dota_creature_naga =
		{
			{
				szText = "Dialog_Naga_LearnAboutCryptHoldout_01",
				szRequireQuestActive = "speak_to_naga",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true, 
				Gesture = ACT_DOTA_CAPTURE,
				szAdvanceQuestActive = "learn_about_crypt_holdout",
			},
			{
				szText = "Dialog_Naga_LearnAboutCryptHoldout_02",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Naga_LearnAboutCryptHoldout_03",
				flAdvanceTime = 10.0,
				bSendToAll = true,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Naga_EscapeTheCrypt",
				szRequireQuestActive = "learn_about_crypt_holdout",
				flAdvanceTime = 30.0,
				bSendToAll = true,
				bAdvance = true, 
				bPlayersConfirm = true,
				szConfirmToken = "LearnAboutCryptHoldout",
				Gesture = ACT_DOTA_IDLE,
				EntsToEnable =
				{
					"crypt_holdout_south_trigger",
					"crypt_holdout_east_trigger",
					"crypt_holdout_north_trigger",
					"crypt_holdout_west_trigger",
				},
			},
		},

		npc_dota_creature_wraith =
		{
			{
				szText = "Dialog_Wraith_Greeting",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_CAPTURE,
			},
			{
				szText = "Dialog_Wraith_Story",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Wraith_Story_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false, 
				Gesture = ACT_DOTA_IDLE,
			},
		},

		npc_dota_creature_octopus =
		{
			{
				szText = "Dialog_Octopus_Greeting",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_CAPTURE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_04",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story_05",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_06",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_07",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story_08",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_09",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_10",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_11",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_12",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_13",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_14",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story_15",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_16",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_17",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_18",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_19",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story_20",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story_bye",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_bye_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_Octopus_Story_bye_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_Octopus_Story_bye_04",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = false, 
				Gesture = ACT_DOTA_IDLE,
			},
		},

		npc_dota_creature_coral_furryfish =
		{
			{
				szText = "Dialog_CoralFurryfish_Greeting",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true,
				Gesture = ACT_DOTA_CAPTURE,
				bForceBreak = true,
			},
			{
				szText = "Dialog_CoralFurryfish_Story",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_CoralFurryfish_Story_02",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_CoralFurryfish_Story_03",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
			{
				szText = "Dialog_CoralFurryfish_Story_04",
				flAdvanceTime = 10.0,
				bSendToAll = false,
				bAdvance = true, 
				Gesture = ACT_DOTA_IDLE,
			},
		},
		npc_dota_journal_note_12 =
		{
			{
				szText = "chef_journal_12",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_journal_note_13 =
		{
			{
				szText = "chef_journal_13",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},	
		npc_dota_journal_note_14 =
		{
			{
				szText = "chef_journal_14",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},	
		npc_dota_journal_note_15 =
		{
			{
				szText = "chef_journal_15",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},	
		npc_dota_journal_note_16 =
		{
			{
				szText = "chef_journal_16",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},	
		npc_dota_journal_note_17 =
		{
			{
				szText = "chef_journal_17",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},	
		npc_dota_journal_note_18 =
		{
			{
				szText = "chef_journal_18",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_01 =
		{
			{
				szText = "warden_log_01",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_02 =
		{
			{
				szText = "warden_log_02",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_03 =
		{
			{
				szText = "warden_log_03",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_04 =
		{
			{
				szText = "warden_log_04",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_05 =
		{
			{
				szText = "warden_log_05",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_06 =
		{
			{
				szText = "warden_log_06",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_07 =
		{
			{
				szText = "warden_log_07",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_08 =
		{
			{
				szText = "warden_log_08",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_09 =
		{
			{
				szText = "warden_log_09",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_10 =
		{
			{
				szText = "warden_log_10",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
		npc_dota_warden_note_11 =
		{
			{
				szText = "warden_log_11",
				flAdvanceTime = 100.0,
				bSendToAll = false,
				bAdvance = false,
				bSkipFacePlayer = true,
			},
		},
	}
end

