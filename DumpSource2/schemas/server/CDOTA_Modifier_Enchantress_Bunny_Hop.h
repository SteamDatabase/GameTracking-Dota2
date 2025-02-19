class CDOTA_Modifier_Enchantress_Bunny_Hop
{
	float32 hop_duration;
	int32 hop_height;
	int32 hop_distance;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flJumpDuration;
	float32 m_flJumpHeight;
	Vector m_vTargetHorizontalDirection;
	CUtlVector< CHandle< CBaseEntity > > hUnitsToHit;
	bool m_bLaunched;
};
