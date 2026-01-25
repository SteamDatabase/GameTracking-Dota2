// MGetKV3ClassDefaults = {
//	"m_vecMaterials":
//	[
//	],
//	"m_vecEconItems":
//	[
//	],
//	"m_vecCraftableRewards":
//	[
//	],
//	"m_vecHeroes":
//	[
//	],
//	"m_vecTradeRecipes":
//	[
//	],
//	"m_mapCodexEntriesLocalized":
//	{
//	},
//	"m_strTokenLocStringPrefix": "",
//	"m_vecSmallRewards":
//	[
//	],
//	"m_vecHunterRankRewardLine":
//	[
//	]
//}
// MVDataRoot
// MVDataSingleton
class CMonsterHunterWorldDefinition
{
	CUtlVector< CMonsterHunterMaterialDefinition > m_vecMaterials;
	CUtlVector< CMonsterHunterEconItemDefinition > m_vecEconItems;
	CUtlVector< CMonsterHunterCraftableRewardDefinition > m_vecCraftableRewards;
	CUtlVector< CMonsterHunterHeroDefinition > m_vecHeroes;
	CUtlVector< CMonsterHunterTradeRecipeDefinition > m_vecTradeRecipes;
	CUtlOrderedMap< CUtlString, CMonsterHunterHeroCodexDefinition > m_mapCodexEntriesLocalized;
	CUtlString m_strTokenLocStringPrefix;
	CUtlVector< CMonsterHunterSmallRewardCategoryDefinition > m_vecSmallRewards;
	CUtlVector< CMonterHunterHunterRankRewardDefinition > m_vecHunterRankRewardLine;
};
