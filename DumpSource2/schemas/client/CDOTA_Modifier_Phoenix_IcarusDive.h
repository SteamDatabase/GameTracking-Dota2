class CDOTA_Modifier_Phoenix_IcarusDive : public CDOTA_Buff
{
	Vector m_vSource;
	Vector m_vTarget;
	Vector m_vDirection;
	QAngle m_angDirection;
	float32 m_flCurrentTime;
	int32 dash_length;
	int32 dash_width;
	int32 hit_radius;
	float32 burn_duration;
	float32 dive_duration;
	float32 impact_damage;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHitEntities;
}
