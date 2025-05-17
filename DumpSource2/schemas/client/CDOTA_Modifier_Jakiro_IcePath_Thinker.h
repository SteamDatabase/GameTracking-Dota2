class CDOTA_Modifier_Jakiro_IcePath_Thinker : public CDOTA_Buff
{
	float32 path_delay;
	float32 path_radius;
	int32 m_nDamage;
	float32 m_flRadius;
	float32 stun_duration;
	int32 detonate_projectile_speed;
	CUtlVector< CHandle< C_BaseEntity > > m_hUnitsHit;
	Vector m_vPathStart;
	Vector m_vPathEnd;
	GameTime_t m_fStartTime;
};
