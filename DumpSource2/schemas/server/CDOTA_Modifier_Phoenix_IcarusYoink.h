class CDOTA_Modifier_Phoenix_IcarusYoink : public CDOTA_Buff
{
	Vector m_vSource;
	Vector m_vTarget;
	Vector m_vDirection;
	QAngle m_angDirection;
	float32 m_flCurrentTime;
	float32 dash_length;
	float32 dash_width;
	float32 hit_radius;
	float32 burn_duration;
	float32 dive_duration;
	float32 impact_damage;
	CUtlVector< CHandle< CBaseEntity > > m_vecHitEntities;
	CHandle< CBaseEntity > hTarget;
};
