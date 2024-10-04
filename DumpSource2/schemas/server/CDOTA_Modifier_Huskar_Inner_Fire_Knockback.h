class CDOTA_Modifier_Huskar_Inner_Fire_Knockback : public CDOTA_Buff
{
	Vector m_vDirection;
	float32 m_flEndTime;
	float32 m_flCurTime;
	float32 knockback_distance;
	float32 knockback_duration;
	float32 effective_distance;
}
