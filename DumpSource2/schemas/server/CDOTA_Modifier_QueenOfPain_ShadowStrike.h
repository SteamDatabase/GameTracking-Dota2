class CDOTA_Modifier_QueenOfPain_ShadowStrike : public CDOTA_Buff
{
	int32 duration_damage;
	int32 duration_heal;
	int32 movement_slow;
	CountdownTimer m_SlowInterval;
	float32 m_flSlowStep;
	float32 m_flSlowStepStep;
	float32 attack_buff_duration;
};
