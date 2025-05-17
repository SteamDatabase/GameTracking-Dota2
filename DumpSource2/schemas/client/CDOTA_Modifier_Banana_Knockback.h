class CDOTA_Modifier_Banana_Knockback : public CDOTA_Buff
{
	Vector m_vCenter;
	int32 knockback_distance;
	int32 knockback_height;
	float32 knockback_duration;
	Vector m_vHorizOffset;
	Vector m_vStartPosition;
	Vector m_vDir;
	float32 m_fCurrentTimeHoriz;
	float32 m_fCurrentTimeVert;
	bool m_bShouldStun;
	float32 flTimeSinceChange;
};
