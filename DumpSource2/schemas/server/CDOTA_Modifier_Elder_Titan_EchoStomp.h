class CDOTA_Modifier_Elder_Titan_EchoStomp : public CDOTA_Buff
{
	int32 wake_damage_limit;
	float32 animation_rate;
	float32 initial_stun_duration;
	CountdownTimer ctStunTimer;
	float32 m_flDamageTaken;
};
