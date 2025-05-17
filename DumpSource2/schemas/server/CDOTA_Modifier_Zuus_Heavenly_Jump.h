class CDOTA_Modifier_Zuus_Heavenly_Jump : public CDOTA_Buff
{
	float32 hop_duration;
	int32 hop_height;
	int32 hop_distance;
	int32 search_radius;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flJumpDuration;
	float32 m_flJumpHeight;
	Vector m_vTargetHorizontalDirection;
	CUtlVector< CHandle< CBaseEntity > > hUnitsToHit;
	bool m_bLaunched;
};
