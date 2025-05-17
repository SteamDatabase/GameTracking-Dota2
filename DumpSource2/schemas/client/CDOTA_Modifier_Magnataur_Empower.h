class CDOTA_Modifier_Magnataur_Empower : public CDOTA_Buff
{
	int32 bonus_damage_pct;
	float32 cleave_damage_pct;
	float32 cleave_starting_width;
	float32 cleave_ending_width;
	float32 cleave_distance;
	float32 self_multiplier;
	float32 secondary_cleave_distance;
	float32 self_multiplier_bonus_stack_duration;
	int32 self_multiplier_bonus_max_stacks;
	int32 self_multiplier_bonus_per_stack;
};
