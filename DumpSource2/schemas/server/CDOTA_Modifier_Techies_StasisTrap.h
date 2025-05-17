class CDOTA_Modifier_Techies_StasisTrap : public CDOTA_Modifier_Invisible
{
	float32 activation_radius;
	float32 stun_radius;
	float32 stun_duration;
	float32 explode_delay;
	float32 activation_time;
	bool m_bActivated;
	bool m_bTriggered;
};
