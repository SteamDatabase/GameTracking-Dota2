class CDOTA_Modifier_PoisonNova_Thinker
{
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CUtlVector< CHandle< CBaseEntity > > m_entitiesHit;
	int32 speed;
	int32 radius;
	int32 start_radius;
	float32 duration;
};
