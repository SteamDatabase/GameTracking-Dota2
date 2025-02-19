class CDOTA_Modifier_VoidSpirit_ResonantPulse_Ring
{
	float32 m_fLastRadius;
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > m_EntitiesHit;
	int32 speed;
	int32 radius;
	int32 damage;
};
