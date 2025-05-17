// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CSurvivorsEnemyDefinition::Attack
{
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticleName;
	float32 m_flDamage;
	float32 m_flAttackCooldown;
	float32 m_flSpeed;
	float32 m_flRange;
	float32 m_flMaxDistance;
	float32 m_flLifeTime;
	float32 m_flAttackOffsetUp;
	float32 m_flAttackOffsetForward;
	float32 m_flRadius;
	GameActivity_t m_activity;
	float32 m_flAttackPoint;
	bool m_bHasIndicator;
	float32 m_flSpawnDelay;
	SurvivorsAttackIndicatorShape_t m_eIndicatorShape;
};
