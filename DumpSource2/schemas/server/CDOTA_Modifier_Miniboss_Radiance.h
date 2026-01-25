class CDOTA_Modifier_Miniboss_Radiance : public CDOTA_Buff
{
	float32 aura_radius;
	float32 attack_timer_duration;
	CountdownTimer m_LastAttackedTimer;
};
