class CDOTA_Modifier_TemplarAssassin_Trap_Slow : public CDOTA_Buff
{
	int32 movement_speed_min;
	int32 movement_speed_max;
	int32 extra_damage;
	float32 trap_max_charge_duration;
	float32 min_silence_duration;
	float32 max_silence_duration;
	float32 stage;
	float32 flDamagePerTick;
	bool bExtraDamage;
}
