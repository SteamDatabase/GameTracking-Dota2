class CDOTA_Modifier_BackdoorProtection : public CDOTA_Buff
{
	bool m_bActivated;
	float32 m_flHealthToRestore;
	int32 radius;
	float32 activation_time;
	int32 regen_rate;
	CountdownTimer m_TimerToActivate;
}
