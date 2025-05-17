class CDOTA_Modifier_Life_Stealer_Open_Wounds : public CDOTA_Buff
{
	int32[8] slow_steps;
	int32 heal_percent;
	int32 m_nDamageTracker;
	int32 damage_threshold;
	float32 spread_radius;
	int32 max_health_as_damage_pct;
};
