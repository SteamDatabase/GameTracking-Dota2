class CDOTA_Modifier_Hoodwink_Scurry_Active : public CDOTA_Buff
{
	int32 movement_speed_pct;
	int32 attack_range;
	int32 cast_range;
	float32 radius_increase;
	float32 m_flTreeDuration;
	float32 evasion_multiplier;
	bool m_bIgnoreInCalc;
	GameTime_t m_flLastCalculationTime;
	float32 m_flTotalEvasion;
};
