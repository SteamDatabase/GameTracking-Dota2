class CDOTA_Modifier_AghsFort_Ascension_PlasmaField_Thinker : public CDOTA_Buff
{
	float32 m_fLastRadius;
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	bool m_bWindingUp;
	CountdownTimer m_ViewerTimer;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_EntitiesHit;
	int32 speed;
	int32 radius;
	int32 damage_min;
	int32 damage_max;
	int32 slow_min;
	int32 slow_max;
	float32 slow_duration;
	float32 windup_time;
};
