class CDOTA_Modifier_Lion_FingerPunch : public CDOTA_Buff
{
	float32 punch_attack_range;
	float32 punch_bonus_damage_base;
	float32 punch_bonus_damage_per_stack;
	float32 cleave_starting_width;
	float32 cleave_ending_width;
	float32 cleave_distance;
	float32 cleave_damage;
	int32 m_iOriginalAttackCapabilities;
};
