// MGetKV3ClassDefaults = {
//	"m_gameModeID": 0,
//	"m_playerSnapshot":
//	{
//		"m_heroID": 0,
//		"m_nCurrentLevel": 1,
//		"m_flCurrentExp": 0.000000,
//		"m_nRerollsRemaining": 0,
//		"m_vecPowerUps":
//		[
//		],
//		"m_vOrigin":
//		[
//			0.000000,
//			0.000000,
//			0.000000
//		]
//	},
//	"m_enemiesSnapshot":
//	[
//	],
//	"m_pickupsSnapshot":
//	[
//	],
//	"m_flGameTime": 0.000000,
//	"m_nCurrentLevelEvent": 0
//}
// MVDataRoot
class CSurvivorsGameSnapshot
{
	SurvivorsGameModeID_t m_gameModeID;
	CSurvivorsPlayerSnapshot m_playerSnapshot;
	CUtlVector< CSurvivorsEnemySnapshot > m_enemiesSnapshot;
	CUtlVector< CSurvivorsPickupSnapshot > m_pickupsSnapshot;
	float32 m_flGameTime;
	int32 m_nCurrentLevelEvent;
};
