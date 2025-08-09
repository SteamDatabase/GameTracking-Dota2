// MGetKV3ClassDefaults = {
//	"_class": "ArtyGameObjectDef_t",
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
//	]
//}
// MVDataRoot
// MVDataNodeType = 1
class ArtyGameObjectDef_t
{
	ArtyGameObjectID_t m_unID;
	// MPropertyCustomFGDType = "vdata_choice:scripts/events/crownfall/artillery_graphics.vdata"
	CUtlString m_szGraphicsDef;
	CUtlString m_szDeathSound;
	EArtyHitboxType m_eHitboxType;
	Vector2D m_vHitboxMin;
	Vector2D m_vHitboxMax;
	float32 m_flHitboxRadius;
	float32 m_flHitboxExtents;
	bool m_bInheritTransform;
	bool m_bInheritRotation;
	bool m_bInheritVisibility;
	bool m_bInheritState;
	bool m_bDestroyOnFallThrough;
	float32 m_flFallDamagePerVelocity;
	bool m_bDeathCausesExplosion;
	float32 m_flExplosionDamage;
	float32 m_flExplosionRadius;
	float32 m_flExplosionTerrainRadius;
	float32 m_flGravityMult;
	float32 m_flDragMult;
	float32 m_flWindMult;
	float32 m_flDeathMaxScaleFactor;
	bool m_bAllowPhysicsInDying;
	EArtyGameObjectType m_eType;
	EArtyLayer m_eLayer;
	float32 m_flMaxHealth;
	float32 m_flHealth;
	bool m_bVisible;
	bool m_bCanCollide;
	bool m_bDoPhysics;
	float32 m_flLifetime;
	float32 m_flDieTime;
	CUtlVector< ArtyGameObjectInstance_t > m_vecChildren;
};
