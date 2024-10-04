class CDOTA_Modifier_Techies_LandMine : public CDOTA_Modifier_Invisible
{
	float32 radius;
	float32 proximity_threshold;
	float32 damage;
	float32 activation_delay;
	float32 outer_damage;
	int32 min_distance;
	bool bActivated;
	CountdownTimer m_Timer;
}
