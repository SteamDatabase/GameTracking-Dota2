class CSurvivorsUnit : public CSurvivorsEntity
{
	SurvivorsUnitID_t m_id;
	float32 m_flHealth;
	float32 m_flMaxHealth;
	bool m_bInvulnerable;
	Vector2D m_vFacing;
	float32 m_flMovementSpeed;
	float32 m_flMass;
	float32 m_flKnockbackResistance;
	float32 m_flStatusResistance;
	float32 m_flBodyRadius;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_playingStatusParticle;
};
