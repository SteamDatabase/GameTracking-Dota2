class CDOTA_Modifier_MonkeyKing_BoundlessStrike_ShardMovement : public CDOTA_Buff
{
	float32 m_flPredictedTotalTime;
	Vector m_vStartPosition;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bHorizontalMotionInterrupted;
	Vector m_vHorizontalVelocity;
	Vector m_vLastKnownTargetPosition;
	float32 m_flInitialVelocityZ;
	int32 acceleration_z;
	int32 min_height_above_lowest;
	int32 min_height_above_highest;
	int32 max_horizontal_acceleration;
	int32 spring_channel_pct;
}
