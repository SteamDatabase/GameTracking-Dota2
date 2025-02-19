class CDOTA_Modifier_PrimalBeast_Onslaught_Knockback
{
	Vector m_vLoc;
	float32 m_flPredictedTotalTime;
	Vector m_vStartPosition;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	bool m_bHorizontalMotionInterrupted;
	bool m_bTargetTeleported;
	Vector m_vHorizontalVelocity;
	Vector m_vLastKnownTargetPosition;
	float32 m_flInitialVelocityZ;
};
