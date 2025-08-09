// MGetKV3ClassDefaults = {
//	"_class": "ArtySpawnerDef_t",
//	"m_unID": 0,
//	"m_szGraphicsDef": "",
//	"m_szDeathSound": "",
//	"m_eHitboxType": "k_eCircle",
//	"m_vHitboxMin":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_vHitboxMax":
//	[
//		0.000000,
//		0.000000
//	],
//	"m_flHitboxRadius": 1.000000,
//	"m_flHitboxExtents": 1.000000,
//	"m_bInheritTransform": false,
//	"m_bInheritRotation": true,
//	"m_bInheritVisibility": false,
//	"m_bInheritState": true,
//	"m_bDestroyOnFallThrough": true,
//	"m_flFallDamagePerVelocity": 1.000000,
//	"m_bDeathCausesExplosion": false,
//	"m_flExplosionDamage": 0.000000,
//	"m_flExplosionRadius": -1.000000,
//	"m_flExplosionTerrainRadius": -1.000000,
//	"m_flGravityMult": 1.000000,
//	"m_flDragMult": 1.000000,
//	"m_flWindMult": 1.000000,
//	"m_flDeathMaxScaleFactor": 1.000000,
//	"m_bAllowPhysicsInDying": false,
//	"m_eType": "k_eTypeObject",
//	"m_eLayer": "k_eDefault",
//	"m_flMaxHealth": 1.000000,
//	"m_flHealth": 1.000000,
//	"m_bVisible": true,
//	"m_bCanCollide": true,
//	"m_bDoPhysics": false,
//	"m_flLifetime": -1.000000,
//	"m_flDieTime": 0.100000,
//	"m_vecChildren":
//	[
//	],
//	"m_flInitialDelay": 0.000000,
//	"m_flDelayBetween": 5.000000,
//	"m_nNumToSpawn": 1,
//	"m_eSpawnedUnitTeam": "k_eThem",
//	"m_szGameObject": ""
//}
class ArtySpawnerDef_t : public ArtyGameObjectDef_t
{
	float32 m_flInitialDelay;
	float32 m_flDelayBetween;
	int32 m_nNumToSpawn;
	EArtyTeam m_eSpawnedUnitTeam;
	CUtlString m_szGameObject;
};
