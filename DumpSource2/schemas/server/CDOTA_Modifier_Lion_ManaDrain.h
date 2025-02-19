class CDOTA_Modifier_Lion_ManaDrain
{
	int32 mana_per_second;
	int32 break_distance;
	float32 tick_interval;
	int32 movespeed;
	int32 damage_pct;
	int32 ally_pct;
	int32 movespeed_bonus_when_empty_pct;
	GameTime_t m_fAppliedTime;
	int32 m_nTotalManaDrained;
	int32 m_nSelfBuffSerialNumber;
	int32 m_nTargetDebuffSerialNumber;
};
