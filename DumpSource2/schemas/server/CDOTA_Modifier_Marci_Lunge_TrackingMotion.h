class CDOTA_Modifier_Marci_Lunge_TrackingMotion : public CDOTA_Buff
{
	int32 m_nProjectileID;
	int32 m_nMaxJumpDistance;
	int32 landing_radius;
	int32 max_jump_distance;
	int32 min_jump_distance;
	int32 target_abort_distance;
	int32 impact_position_offset;
	float32 m_flCastDistance;
	ParticleIndex_t m_nAoEFXIndex;
	Vector m_vDestination;
	CHandle< CBaseEntity > m_hBounceEntity;
	CHandle< CBaseEntity > m_hBounceEntityClient;
}
