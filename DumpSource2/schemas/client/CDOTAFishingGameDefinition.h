// MGetKV3ClassDefaults = {
//	"m_strID": "",
//	"m_bBurrowedFish": false,
//	"m_strMapName": "",
//	"m_strBurrowedFishParticle": "",
//	"m_vecFishTypes":
//	[
//	],
//	"m_mapFishNameToVecIndex":
//	{
//	},
//	"m_mapCategoryToDifficulty":
//	{
//	}
//}
// MVDataRoot
// MVDataSingleton
class CDOTAFishingGameDefinition
{
	CUtlString m_strID;
	bool m_bBurrowedFish;
	CUtlString m_strMapName;
	CUtlString m_strBurrowedFishParticle;
	CUtlVector< CDOTAFishingGameFish* > m_vecFishTypes;
	CUtlOrderedMap< CUtlString, int32 > m_mapFishNameToVecIndex;
	CUtlOrderedMap< EFishingGameFishCategory, float32 > m_mapCategoryToDifficulty;
};
