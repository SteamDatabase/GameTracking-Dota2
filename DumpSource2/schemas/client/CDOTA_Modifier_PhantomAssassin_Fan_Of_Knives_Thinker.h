class CDOTA_Modifier_PhantomAssassin_Fan_Of_Knives_Thinker : public CDOTA_Buff
{
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CUtlVector< CHandle< C_BaseEntity > > m_entitiesHit;
	CountdownTimer m_ViewerTimer;
	int32 projectile_speed;
	int32 radius;
	float32 duration;
	float32 pct_health_damage_initial;
	float32 max_damage_initial;
}
