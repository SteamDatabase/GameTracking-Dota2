class CDOTA_Modifier_Batrider_Smoldering_Resin_Debuff
{
	float32 damage;
	float32 tick_rate;
	int32 tick_attack_damage_pct;
	int32 total_ticks;
	CUtlVector< float32 > m_nDamageQueue;
};
