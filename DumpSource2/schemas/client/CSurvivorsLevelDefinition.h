// MGetKV3ClassDefaults = {
//	"m_unLevelID": 0,
//	"m_vecEvents":
//	[
//	],
//	"m_vecBossEvents":
//	[
//	],
//	"m_vMapBounds":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_vEntityBounds":
//	[
//		0.000000,
//		0.000000
//	]
//}
// MVDataRoot
class CSurvivorsLevelDefinition
{
	SurvivorsLevelID_t m_unLevelID;
	CUtlVector< CSurvivorsEnemyEventDefinition > m_vecEvents;
	CUtlVector< CSurvivorsEnemyEventDefinition > m_vecBossEvents;
	Vector2D m_vMapBounds;
	Vector2D m_vEntityBounds;
};
