// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
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
