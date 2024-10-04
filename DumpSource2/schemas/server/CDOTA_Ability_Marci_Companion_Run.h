class CDOTA_Ability_Marci_Companion_Run : public CDOTABaseAbility
{
	int32 m_nTrackingProjectileID;
	ParticleIndex_t m_nFXIndex;
	int32 m_nMaxJumpDistance;
	int32 landing_radius;
	int32 move_speed;
	float32 ally_buff_duration;
	int32 min_jump_distance;
	int32 max_jump_distance;
	int32 impact_position_offset;
	int32 vector_preview_radius;
	Vector m_vEndpoint;
	ParticleIndex_t m_nToBounceFXIndex;
	ParticleIndex_t m_nToTargetFXIndex;
	Vector m_vDashPosition;
	Vector m_vFacePosition;
	Vector m_vTravelDir;
	float32 m_fTravelDistance;
}
