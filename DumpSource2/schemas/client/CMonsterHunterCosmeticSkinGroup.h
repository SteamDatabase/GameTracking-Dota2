// MGetKV3ClassDefaults = {
//	"m_strSetName": "",
//	"m_vecActionIDSlots":
//	[
//	],
//	"m_bRequiresPremium": false,
//	"m_bShowPremiumPurchaseAsCrafting": false,
//	"m_strCustomClass": "",
//	"m_strCustomStyleSelectAnimation": "",
//	"m_flAnimationFreezeTime": -1.000000,
//	"m_flCustomStyleSelectRotation": 0.000000,
//	"m_unPreviewItemIndex": 0
//}
class CMonsterHunterCosmeticSkinGroup
{
	CUtlString m_strSetName;
	CUtlVector< uint32 > m_vecActionIDSlots;
	bool m_bRequiresPremium;
	bool m_bShowPremiumPurchaseAsCrafting;
	CUtlString m_strCustomClass;
	CUtlString m_strCustomStyleSelectAnimation;
	float32 m_flAnimationFreezeTime;
	float32 m_flCustomStyleSelectRotation;
	item_definition_index_t m_unPreviewItemIndex;
};
