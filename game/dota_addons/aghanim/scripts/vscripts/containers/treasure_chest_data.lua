
_G.TreasureChestData =
{
	{
		fSpawnChance = 1, --0.5,
		szSpawnerName = "treasure_chest",
		szNPCName = "npc_treasure_chest",
		nMaxSpawnDistance = 0,

		fNeutralItemChance = 0.4,
		nMinNeutralItems = 1,
		nMaxNeutralItems = 2,

		fItemChance = 0.4,
		nMinItems = 1,
		nMaxItems = 2,
		Items =
		{
			"item_life_rune",
		},

		fTrapChance = 0.0,
		nTrapLevel = 1,
		szTraps =
		{
			"creature_techies_land_mine",
			"trap_sun_strike",
		},
	},
}
