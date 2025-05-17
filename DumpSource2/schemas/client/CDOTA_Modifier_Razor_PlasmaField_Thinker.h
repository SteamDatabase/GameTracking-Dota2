class CDOTA_Modifier_Razor_PlasmaField_Thinker : public CDOTA_Buff
{
	float32 m_fLastRadius;
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	bool m_bContracting;
	CountdownTimer m_ViewerTimer;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > m_EntitiesHit;
	int32 speed;
	float32 radius;
	float32 damage_min;
	float32 damage_max;
	int32 slow_min;
	int32 slow_max;
	float32 slow_duration;
	bool m_bHasCreatedFx;
	float32 total_ability_time;
};
