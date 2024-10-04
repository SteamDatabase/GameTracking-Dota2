class CDOTA_Modifier_Nian_Whirlpool_Pull : public CDOTA_Buff
{
	int32 pull_radius;
	int32 pull_speed;
	int32 radius;
	int32 whirlpool_damage;
	float32 tick_rate;
	GameTime_t m_flDamageTick;
	CHandle< CBaseEntity > m_hThinker;
}
