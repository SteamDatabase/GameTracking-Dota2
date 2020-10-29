_G.DIRETIDE_RANDOM_SPAWNS = 
{
	{
		SpawnerName =	"creep_spawn_top",
		Waypoint =		"path_top"
	},
	{
		SpawnerName =	"creep_spawn_bot",
		Waypoint =		"path_bot"
	},
}

_G.DIRETIDE_WAVES =
{
	Round1 =
	{
		round_name =				"#DOTA_Holdout_Round_Skeletons",
		MaxGold =					2500,
		FixedXP =					3730,
		PointReward =				0,
		DeniesBeforeLimitRewards =	5,
		
		Waves =
		{
			Skeletons1 =
			{
				WaitForTime = 0,
				GroupsToSpawn = 2,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_skeleton",
						UnitCount = 5,
						CandyCount = 3,
					},
				},
			},
			Skeletons2 =
			{
				WaitForTime = 60,
				GroupsToSpawn = 5,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_skeleton",
						UnitCount = 5,
						CandyCount = 4,
					},
					{
						NPCName = "npc_dota_creature_dark_troll_warlord",
						UnitCount = 1,
						CandyCount = 1,
					},
				},
			},
			Skeletons3 =
			{
				WaitForTime = 210,
				GroupsToSpawn = 4,
				SpawnInterval = 30,
				
				RepeatInfinitely = true,
				Units =
				{
					{
						NPCName = "npc_dota_creature_skeleton",
						UnitCount = 7,
						CandyCount = 5,
					},
					{
						NPCName = "npc_dota_creature_dark_troll_warlord",
						UnitCount = 1,
						CandyCount = 1,
					},
				},
			},
		},
	},

	Round2 =
	{
		round_name =				"#DOTA_Holdout_Round_Zombies",
		MaxGold =					3200,
		FixedXP =					6075,
		PointReward =				0,
		DeniesBeforeLimitRewards =	5,

		Waves =
		{
			Zombies1 =
			{
				WaitForTime = 0,
				GroupsToSpawn = 2,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_zombie_basic",
						UnitCount = 4,
						CandyCount = 2,
					},
					{
						NPCName = "npc_dota_creature_zombie_torso",
						UnitCount = 2,
						CandyCount = 1,
					},
				},
			},
			-- we stagger the next two spawns so that we can alternate between waves with ogreseals and waves without
			Zombies2a =
			{
				WaitForTime = 60,
				GroupsToSpawn = 3,
				SpawnInterval = 60,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_zombie_basic",
						UnitCount = 5,
						CandyCount = 2,
					},
					{
						NPCName = "npc_dota_creature_zombie_torso",
						UnitCount = 2,
						CandyCount = 1,
					},
					{
						NPCName = "npc_dota_creature_zombie_ogreseal",
						UnitCount = 1,
						CandyCount = 2,
					},
				},
			},
			Zombies2b =
			{
				WaitForTime = 90,
				GroupsToSpawn = 2,
				SpawnInterval = 60,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_zombie_basic",
						UnitCount = 5,
						CandyCount = 3,
					},
					{
						NPCName = "npc_dota_creature_zombie_torso",
						UnitCount = 3,
						CandyCount = 2,
					},
				},
			},
			Zombies3 =
			{
				WaitForTime = 210,
				GroupsToSpawn = 4,
				SpawnInterval = 30,
				
				RepeatInfinitely = true,
				Units =
				{
					{
						NPCName = "npc_dota_creature_zombie_basic",
						UnitCount = 7,
						CandyCount = 3,
					},
					{
						NPCName = "npc_dota_creature_zombie_torso",
						UnitCount = 3,
						CandyCount = 1,
					},
					{
						NPCName = "npc_dota_creature_zombie_ogreseal",
						UnitCount = 1,
						CandyCount = 2,
					},
				},
			},
		},
	},

	Round3 =
	{
		round_name =				"#DOTA_Holdout_Round_Hulks",
		MaxGold =					4100,
		FixedXP =					8240,
		PointReward =				0,
		DeniesBeforeLimitRewards =	1,

		Waves =
		{
			Pumpkins1 =
			{
				WaitForTime = 0,
				GroupsToSpawn = 6,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCNameRadiant = "npc_dota_creature_hulk_radiant",
						NPCNameDire = "npc_dota_creature_hulk_dire",
						UnitCount = 1,
						CandyCount = 3,
					},
				},
			},
			Pumpkins2 =
			{
				WaitForTime = 180,
				GroupsToSpawn = 3,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCNameRadiant = "npc_dota_creature_hulk_radiant",
						NPCNameDire = "npc_dota_creature_hulk_dire",
						UnitCount = 2,
						CandyCount = 6,
					},
				},
			},
			Pumpkins3 =
			{
				WaitForTime = 270,
				GroupsToSpawn = 2,
				SpawnInterval = 30,
				
				RepeatInfinitely = true,
				Units =
				{
					{
						NPCNameRadiant = "npc_dota_creature_hulk_radiant",
						NPCNameDire = "npc_dota_creature_hulk_dire",
						UnitCount = 3,
						CandyCount = 9,
					},
				},
			},
		},
	},

	Round4 =
	{
		round_name =				"#DOTA_Holdout_Round_Ghosts",
		MaxGold =					5200,
		FixedXP =					10500,
		PointReward =				0,
		DeniesBeforeLimitRewards =	5,

		Waves =
		{
			Group1 =
			{
				WaitForTime = 0,
				GroupsToSpawn = 3,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_melee_ghost",
						UnitCount = 5,
						CandyCount = 2,
					},
				},
			},
			Group2 =
			{
				WaitForTime = 60,
				GroupsToSpawn = 5,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_melee_ghost",
						UnitCount = 6,
						CandyCount = 2,
					},
					{
						NPCName = "npc_dota_creature_ranged_ghost",
						UnitCount = 1,
						CandyCount = 2,
					},
				},
			},
			Group3 =
			{
				WaitForTime = 210,
				GroupsToSpawn = 4,
				SpawnInterval = 30,
				
				RepeatInfinitely = true,
				Units =
				{
					{
						NPCName = "npc_dota_creature_melee_ghost",
						UnitCount = 6,
						CandyCount = 3,
					},
					{
						NPCName = "npc_dota_creature_ranged_ghost",
						UnitCount = 2,
						CandyCount = 4,
					},
				},
			},
		},
	},

	Round5 =
	{
		round_name =				"#DOTA_Holdout_Round_Spiders",
		MaxGold =					6700,
		FixedXP =					55000,
		PointReward =				0,
		DeniesBeforeLimitRewards =	4,
		
		Waves =
		{
			Spiders1 =
			{
				WaitForTime = 0,
				GroupsToSpawn = 2,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_huge_broodmother",
						UnitCount = 1,
						CandyCount = 3,
					},
				},
			},
			Spiders2 =
			{
				WaitForTime = 60,
				GroupsToSpawn = 4,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_visage_familiar1",
						UnitCount = 6,
						CandyCount = 2,
					},
					{
						NPCName = "npc_dota_creature_huge_broodmother",
						UnitCount = 1,
						CandyCount = 3,
					},
				},
			},
			Spiders3 =
			{
				WaitForTime = 180,
				GroupsToSpawn = 2,
				SpawnInterval = 30,
				
				Units =
				{
					{
						NPCName = "npc_dota_creature_visage_familiar1",
						UnitCount = 12,
						CandyCount = 3,
					},
				},
			},
			Spiders4 =
			{
				WaitForTime = 240,
				GroupsToSpawn = 3,
				SpawnInterval = 30,
				
				RepeatInfinitely = true,
				Units =
				{
					{
						NPCName = "npc_dota_creature_visage_familiar1",
						UnitCount = 9,
						CandyCount = 5,
					},
					{
						NPCName = "npc_dota_creature_huge_broodmother",
						UnitCount = 1,
						CandyCount = 3,
					},
				},
			},
		},
	},

}
