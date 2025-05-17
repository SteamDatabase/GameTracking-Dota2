class CDOTA_Modifier_KeeperOfTheLight_Illuminate : public CDOTA_Buff
{
	float32 range;
	float32 total_damage;
	float32 radius;
	float32 max_channel_time;
	float32 speed;
	float32 channel_vision_radius;
	float32 channel_vision_interval;
	float32 channel_vision_duration;
	float32 channel_vision_step;
	GameTime_t m_flLastChantTime;
	Vector m_vNextVisionLocation;
	Vector m_vCastDirection;
	Vector m_vCastLoc;
	QAngle m_qCastAngle;
	ParticleIndex_t m_nFXIndex;
	bool m_bIsSpiritForm;
	GameTime_t m_fStartTime;
};
