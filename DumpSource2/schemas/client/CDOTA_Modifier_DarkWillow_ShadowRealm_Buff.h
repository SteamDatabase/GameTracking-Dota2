class CDOTA_Modifier_DarkWillow_ShadowRealm_Buff : public CDOTA_Buff
{
	int32 damage;
	float32 max_damage_duration;
	int32 attack_range_bonus;
	CUtlVector< int16 > m_InFlightAttackRecords;
	bool bAttackRange;
	GameTime_t m_flStartTime;
	GameTime_t m_flFadeTime;
	float32 m_flDamageScale;
	float32 duration;
	float32 aura_radius;
};
