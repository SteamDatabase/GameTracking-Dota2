class CDOTA_Modifier_Magnataur_Horn_Toss : public CDOTA_Buff
{
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
