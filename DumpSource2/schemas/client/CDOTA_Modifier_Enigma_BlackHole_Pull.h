class CDOTA_Modifier_Enigma_BlackHole_Pull : public CDOTA_Buff
{
	int32 pull_speed;
	float32 radius;
	float32 damage;
	float32 tick_rate;
	float32 pull_rotate_speed;
	float32 animation_rate;
	float32 scepter_pct_damage;
	float32 m_flBlackHoleDuration;
	float32 m_flBlackHoleCreationTime;
	GameTime_t m_flDamageTick;
};
