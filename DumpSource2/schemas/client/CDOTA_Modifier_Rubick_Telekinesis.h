class CDOTA_Modifier_Rubick_Telekinesis : public CDOTA_Buff
{
	GameTime_t m_fStartTime;
	GameTime_t m_fEndTime;
	float32 m_fTargetHeight;
	float32 m_fCurHeight;
	Vector m_vStartLoc;
	Vector m_vCurLoc;
	int32 max_land_distance;
	float32 fall_duration;
	bool m_bOverrideDuration;
	float32 m_flOverrideDuration;
};
