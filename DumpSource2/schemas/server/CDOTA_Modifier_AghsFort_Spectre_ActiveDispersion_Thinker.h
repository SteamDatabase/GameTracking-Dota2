class CDOTA_Modifier_AghsFort_Spectre_ActiveDispersion_Thinker
{
	float32 m_fDamage;
	float32 m_fLastRadius;
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	bool m_bContracting;
	CountdownTimer m_ViewerTimer;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_EntitiesHit;
	int32 speed;
	int32 radius;
};
