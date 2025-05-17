class CDOTA_Modifier_Marci_Grapple_VictimMotion : public CDOTA_Buff
{
	int32 impact_damage;
	float32 debuff_duration;
	float32 landing_radius;
	float32 air_duration;
	int32 air_height;
	int32 travel_distance;
	Vector m_vDestination;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flJumpDuration;
	float32 m_flJumpHeight;
	Vector m_vTargetHorizontalDirection;
};
