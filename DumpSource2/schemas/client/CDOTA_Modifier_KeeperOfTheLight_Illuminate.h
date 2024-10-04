class CDOTA_Modifier_KeeperOfTheLight_Illuminate : public CDOTA_Buff
{
	int32 range;
	int32 total_damage;
	int32 radius;
	float32 max_channel_time;
	int32 speed;
	int32 channel_vision_radius;
	float32 channel_vision_interval;
	float32 channel_vision_duration;
	int32 channel_vision_step;
	GameTime_t m_flLastChantTime;
	Vector m_vNextVisionLocation;
	Vector m_vCastDirection;
	Vector m_vCastLoc;
	QAngle m_qCastAngle;
	ParticleIndex_t m_nFXIndex;
	bool m_bIsSpiritForm;
	GameTime_t m_fStartTime;
};
