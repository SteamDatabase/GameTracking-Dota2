// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_vecPrefixes":
//	[
//	],
//	"m_vecSuffixes":
//	[
//	],
//	"m_vecGems":
//	[
//	],
//	"m_vecShapes":
//	[
//	],
//	"m_vecQualities":
//	[
//	],
//	"m_vecTablets":
//	[
//	],
//	"m_vecOperations":
//	[
//	]
//}
// MPropertyAutoExpandSelf
class FantasyCraftSetupData_t
{
	// MPropertyDescription = "Unique identifier for this set of crafting data"
	FantasyCraftDataID_t m_unID;
	CUtlVector< FantasyCraftingTitleData_t > m_vecPrefixes;
	CUtlVector< FantasyCraftingTitleData_t > m_vecSuffixes;
	CUtlVector< FantasyCraftingGemData_t > m_vecGems;
	CUtlVector< FantasyCraftingShapeData_t > m_vecShapes;
	CUtlVector< FantasyCraftingQualityData_t > m_vecQualities;
	CUtlVector< FantasyCraftingTabletData_t > m_vecTablets;
	CUtlVector< FantasyCraftOperationBucket_t > m_vecOperations;
};
