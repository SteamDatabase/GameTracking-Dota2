// MGetKV3ClassDefaults = {
//	"m_nHeroID": 0,
//	"m_flHeroWidth": 0.000000,
//	"m_pszBasicSwingSound": "",
//	"m_pszBasicHitSound": "",
//	"m_nVictoryDuration": 0,
//	"m_pszHeroNameVO": "",
//	"m_vecHeroStyles":
//	[
//	],
//	"m_vecActionDefinitions":
//	[
//	],
//	"m_HeroPick_HeightOffset": 0.000000,
//	"m_HeroPick_XOffset_Right": 0.000000,
//	"m_HeroPick_Angle_Right": 0.000000,
//	"m_HeroPick_XOffset_Left": 0.000000,
//	"m_HeroPick_Angle_Left": 10.000000,
//	"m_HeroPick_Scale": 1.000000
//}
// MVDataRoot
class CDOTAFightingGameHeroDefinition
{
	HeroID_t m_nHeroID;
	float32 m_flHeroWidth;
	CUtlString m_pszBasicSwingSound;
	CUtlString m_pszBasicHitSound;
	int32 m_nVictoryDuration;
	CUtlString m_pszHeroNameVO;
	CUtlVector< CDOTAFightingGameHeroStyleDefinition > m_vecHeroStyles;
	CUtlVector< CDOTAFightingGameActionDefinition > m_vecActionDefinitions;
	float32 m_HeroPick_HeightOffset;
	float32 m_HeroPick_XOffset_Right;
	float32 m_HeroPick_Angle_Right;
	float32 m_HeroPick_XOffset_Left;
	float32 m_HeroPick_Angle_Left;
	float32 m_HeroPick_Scale;
};
