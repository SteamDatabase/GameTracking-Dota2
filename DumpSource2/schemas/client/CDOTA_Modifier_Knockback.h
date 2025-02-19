class CDOTA_Modifier_Knockback
{
	float32 knockback_distance;
	int32 knockback_height;
	float32 knockback_duration;
	Vector m_vHorizOffset;
	Vector m_vStartPosition;
	float32 m_flZDelta;
	float32 m_fCurrentTimeHoriz;
	float32 m_fCurrentTimeVert;
	bool m_bShouldStun;
	bool m_bRespectLeash;
	bool m_bReversePolarity;
	bool m_bRelativeToGround;
};
