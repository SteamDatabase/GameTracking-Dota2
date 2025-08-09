// MGetKV3ClassDefaults = {
//	"m_unID": 0,
//	"m_sLocLevelName": "",
//	"m_playerInfo":
//	{
//		"_class": "ArtyLevelObjectInstance_t",
//		"m_szName": "",
//		"m_szGameObject": "",
//		"m_vPosition":
//		[
//			0.000000,
//			0.000000
//		],
//		"m_flRotation": 0.000000,
//		"m_vScale":
//		[
//			1.000000,
//			1.000000
//		],
//		"m_bFacingLeft": true,
//		"m_flYawOffset": 0.000000,
//		"m_szLeftBorderObject": "",
//		"m_flLeftObjectOffset": 64.000000,
//		"m_szRightBorderObject": "",
//		"m_flRightObjectOffset": 64.000000,
//		"m_bRandomPosition": true,
//		"m_bRepositionToTerrain": true,
//		"m_flLeftBorderWidthMult": 0.500000,
//		"m_flRightBorderWidthMult": 0.975000,
//		"m_flAppearanceChance": 1.000000,
//		"m_eTeam": "k_eThem",
//		"m_flTimeOffset": 2.000000,
//		"m_vecCustomOrders":
//		[
//		]
//	},
//	"m_vecGameObjects":
//	[
//	],
//	"m_vecWeapons":
//	[
//	],
//	"m_nLevelCompletePoints": 0,
//	"m_nTimeBonusBasePoints": 0,
//	"m_nTimeBonusMaxPoints": 0,
//	"m_nTimeBonusFastTime": 0,
//	"m_nTimeBonusMaxTime": 0,
//	"m_flBackgroundOffsetX": 0.000000,
//	"m_aryStarPointThresholds":
//	[
//		0,
//		0,
//		0
//	],
//	"m_sBackgroundImage": "",
//	"m_sTerrainBackgroundImage": "",
//	"m_sTerrainImage": "",
//	"m_sTerrainForegroundImage": ""
//}
// MVDataRoot
class ArtyLevelInfo_t
{
	ArtyLevelID_t m_unID;
	CUtlString m_sLocLevelName;
	ArtyLevelObjectInstance_t m_playerInfo;
	CUtlVector< ArtyLevelObjectInstance_t > m_vecGameObjects;
	CUtlVector< ArtyLevelWeaponInstance_t > m_vecWeapons;
	int32 m_nLevelCompletePoints;
	int32 m_nTimeBonusBasePoints;
	int32 m_nTimeBonusMaxPoints;
	int32 m_nTimeBonusFastTime;
	int32 m_nTimeBonusMaxTime;
	float32 m_flBackgroundOffsetX;
	int32[3] m_aryStarPointThresholds;
	CPanoramaImageName m_sBackgroundImage;
	CPanoramaImageName m_sTerrainBackgroundImage;
	CPanoramaImageName m_sTerrainImage;
	CPanoramaImageName m_sTerrainForegroundImage;
};
