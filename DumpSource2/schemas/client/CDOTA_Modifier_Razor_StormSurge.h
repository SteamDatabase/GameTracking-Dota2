class CDOTA_Modifier_Razor_StormSurge : public CDOTA_Buff
{
	int32 self_movement_speed_pct;
	int32 strike_pct_chance;
	float32 strike_damage;
	int32 strike_move_slow_pct;
	float32 strike_search_radius;
	int32 strike_target_count;
	float32 strike_slow_duration;
	float32 strike_internal_cd;
	float32 strike_cd_reduction_during_storm;
	int32 eye_of_the_storm_chance_multiplier;
};
