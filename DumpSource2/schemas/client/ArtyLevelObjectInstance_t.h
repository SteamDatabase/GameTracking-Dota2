// MGetKV3ClassDefaults = {
//	"_class": "ArtyLevelObjectInstance_t",
//	"m_szName": "",
//	"m_szGameObject": "",
//	"m_vPosition":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_flRotation": 0.000000,
//	"m_vScale":
//	[
//		1.000000,
//		1.000000
//	],
//	"m_bFacingLeft": true,
//	"m_flYawOffset": 0.000000,
//	"m_szLeftBorderObject": "",
//	"m_flLeftObjectOffset": 64.000000,
//	"m_szRightBorderObject": "",
//	"m_flRightObjectOffset": 64.000000,
//	"m_bRandomPosition": true,
//	"m_bRepositionToTerrain": true,
//	"m_flLeftBorderWidthMult": 0.500000,
//	"m_flRightBorderWidthMult": 0.975000,
//	"m_flAppearanceChance": 1.000000,
//	"m_eTeam": "k_eThem",
//	"m_flTimeOffset": 2.000000,
//	"m_vecCustomOrders":
//	[
//	]
//}
class ArtyLevelObjectInstance_t : public ArtyGameObjectInstance_t
{
	CUtlString m_szLeftBorderObject;
	float32 m_flLeftObjectOffset;
	CUtlString m_szRightBorderObject;
	float32 m_flRightObjectOffset;
	bool m_bRandomPosition;
	bool m_bRepositionToTerrain;
	float32 m_flLeftBorderWidthMult;
	float32 m_flRightBorderWidthMult;
	float32 m_flAppearanceChance;
	EArtyTeam m_eTeam;
	float32 m_flTimeOffset;
	CUtlVector< ArtyEnemyOrder_t > m_vecCustomOrders;
};
