class CDOTA_Modifier_WitchDoctor_Maledict : public CDOTA_Buff
{
	int32 m_iStartHealth;
	float32 bonus_damage;
	float32 bonus_damage_threshold;
	int32 ticks;
	int32 iCurrentTick;
	int32 health_restoration_reduction;
	float32 spread_radius;
	float32 spread_pct;
};
