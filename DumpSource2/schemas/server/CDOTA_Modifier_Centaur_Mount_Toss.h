class CDOTA_Modifier_Centaur_Mount_Toss
{
	float32 air_duration;
	int32 air_height;
	int32 travel_distance;
	CHandle< CBaseEntity > m_hTarget;
	float32 m_flPredictedTotalTime;
	Vector m_vStartPosition;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bHorizontalMotionInterrupted;
	bool m_bDamageApplied;
	bool m_bTargetTeleported;
	Vector m_vHorizontalVelocity;
	Vector m_vLastKnownTargetPosition;
	float32 m_flInitialVelocityZ;
	bool m_bDone;
};
