class CDOTA_Modifier_Snapfire_SpitCreep_ArcingUnit : public CDOTA_Buff
{
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
	float32 m_fClampedProjectileSpeed;
	ParticleIndex_t m_nFXIndex;
	float32 m_fAcceleration;
	int32 min_range;
	float32 min_lob_travel_time;
	float32 max_lob_travel_time;
	int32 impact_radius;
	int32 projectile_vision;
	float32 stun_duration;
	float32 min_height_above_lowest;
	float32 min_height_above_highest;
	float32 min_acceleration;
	float32 max_acceleration;
}
