// MGetKV3ClassDefaults = {
//	"m_eTradeConversion": "k_eMonsterHunterMaterialTradeConversion_Invalid",
//	"m_nOfferCount": 1,
//	"m_nResultCount": 1,
//	"m_bOfferTokensMustBeTheSame": false,
//	"m_bCanChooseResult": false,
//	"m_strLocTitle": "",
//	"m_strDescription": "",
//	"m_unUnlockPrerequisiteActionID": 0,
//	"m_unResultActionID": 0,
//	"m_eRequiredOfferRarity": "k_eMonsterHunterMaterialRarity_Invalid"
//}
class CMonsterHunterTradeRecipeDefinition
{
	EMonsterHunterMaterialTradeConversion m_eTradeConversion;
	int32 m_nOfferCount;
	int32 m_nResultCount;
	bool m_bOfferTokensMustBeTheSame;
	bool m_bCanChooseResult;
	CUtlString m_strLocTitle;
	CUtlString m_strDescription;
	uint32 m_unUnlockPrerequisiteActionID;
	uint32 m_unResultActionID;
	EMonsterHunterMaterialRarity m_eRequiredOfferRarity;
};
