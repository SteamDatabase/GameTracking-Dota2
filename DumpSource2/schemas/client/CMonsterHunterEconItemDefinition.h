// MGetKV3ClassDefaults = {
//	"m_unEconItemID": 0,
//	"m_strEconItemNavigationName": "",
//	"m_strCustomClass": "",
//	"m_unPreviewItemIndex": 0,
//	"m_nPreviewPremiumCosmeticGroupIndex": 1,
//	"m_vecCosmeticSkinGroups":
//	[
//	],
//	"m_flPreviewModelRotation": 0.000000,
//	"m_flPreviewModelZoom": 100.000000,
//	"m_bHasDetailedView": false,
//	"m_bCosmeticGroupsNeedToBeCraftedInOrder": true
//}
class CMonsterHunterEconItemDefinition
{
	// MVDataUniqueMonotonicInt = "_editor/next_id_econ_item"
	// MPropertyAttributeEditor = "locked_int()"
	MonsterHunterEconItemID_t m_unEconItemID;
	CUtlString m_strEconItemNavigationName;
	// MPropertyDescription = "Custom panorama classes associated with relevant dashboard elements."
	CUtlString m_strCustomClass;
	// MPropertyDescription = "Optional item used for preview purposes. If left empty, will use the first slot."
	item_definition_index_t m_unPreviewItemIndex;
	int32 m_nPreviewPremiumCosmeticGroupIndex;
	CUtlVector< CMonsterHunterCosmeticSkinGroup > m_vecCosmeticSkinGroups;
	float32 m_flPreviewModelRotation;
	float32 m_flPreviewModelZoom;
	bool m_bHasDetailedView;
	bool m_bCosmeticGroupsNeedToBeCraftedInOrder;
};
