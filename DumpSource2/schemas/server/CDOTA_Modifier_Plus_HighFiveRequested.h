class CDOTA_Modifier_Plus_HighFiveRequested : public CDOTA_Buff
{
	int32 acknowledge_range;
	float32 think_interval;
	float32 acknowledged_cooldown;
	bool m_bAcknowledged;
	bool m_bFirstThink;
	int32 high_five_level;
}
