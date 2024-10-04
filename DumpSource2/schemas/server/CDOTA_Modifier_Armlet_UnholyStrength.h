class CDOTA_Modifier_Armlet_UnholyStrength : public CDOTA_Buff
{
	int32 unholy_bonus_damage;
	int32 unholy_bonus_attack_speed;
	int32 unholy_bonus_strength;
	int32 unholy_bonus_armor;
	int32 unholy_health_drain_per_second;
	int32 str_tick_count;
	int32 unholy_bonus_slow_resistance;
	float32 tick_interval;
	float32 m_flDamageRemainder;
};
