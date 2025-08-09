// MGetKV3ClassDefaults = {
//	"m_strNameInMap": "",
//	"m_nHealth": 1,
//	"m_flHitboxRadius": 1.000000,
//	"m_vHitboxOffsetWS":
//	[
//		0.000000,
//		0.000000,
//		0.000000
//	],
//	"m_nKillScore": 0,
//	"m_flModelScale": 1.000000,
//	"m_bIsBoss": false,
//	"m_vecBulletPatterns":
//	[
//	],
//	"m_vecOnDeathBulletPatterns":
//	[
//	],
//	"m_vecSelfDestroyBulletPatterns":
//	[
//	]
//}
// MVDataRoot
class CShmupEnemyDefinition
{
	CUtlString m_strNameInMap;
	int32 m_nHealth;
	float32 m_flHitboxRadius;
	Vector m_vHitboxOffsetWS;
	int32 m_nKillScore;
	float32 m_flModelScale;
	bool m_bIsBoss;
	// MPropertySuppressExpr = "m_type != k_eShmupPathEventType_Shoot"
	CUtlVector< CShmupBulletInfo > m_vecBulletPatterns;
	CUtlVector< CShmupBulletInfo > m_vecOnDeathBulletPatterns;
	CUtlVector< CShmupBulletInfo > m_vecSelfDestroyBulletPatterns;
};
