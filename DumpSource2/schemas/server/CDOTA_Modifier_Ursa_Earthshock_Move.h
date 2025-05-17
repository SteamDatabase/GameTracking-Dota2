class CDOTA_Modifier_Ursa_Earthshock_Move : public CDOTA_Buff
{
	float32 hop_duration;
	int32 hop_height;
	int32 hop_distance;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flJumpDuration;
	float32 m_flJumpHeight;
	Vector m_vTargetHorizontalDirection;
};
