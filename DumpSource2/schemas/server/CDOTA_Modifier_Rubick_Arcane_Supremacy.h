class CDOTA_Modifier_Rubick_Arcane_Supremacy : public CDOTA_Buff
{
	int32 cast_range;
	int32 spell_amp;
	float32 aoe_bonus;
	float32 aoe_bonus_duration;
	CUtlVector< GameTime_t > m_vecAoEExpireTimes;
};
