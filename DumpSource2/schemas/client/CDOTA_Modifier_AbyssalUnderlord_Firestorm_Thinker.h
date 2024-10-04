class CDOTA_Modifier_AbyssalUnderlord_Firestorm_Thinker : public CDOTA_Buff
{
	int32 wave_damage;
	int32 wave_count;
	float32 radius;
	float32 wave_interval;
	float32 burn_duration;
	float32 burn_interval;
	float32 first_wave_delay;
	float32 building_damage;
	CHandle< C_BaseEntity > m_hTarget;
};
