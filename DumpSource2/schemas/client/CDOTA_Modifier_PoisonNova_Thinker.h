class CDOTA_Modifier_PoisonNova_Thinker : public CDOTA_Buff
{
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CUtlVector< CHandle< C_BaseEntity > > m_entitiesHit;
	int32 speed;
	int32 radius;
	int32 start_radius;
	float32 duration;
}
