class CDOTA_Modifier_Snapfire_FiresnapCookie_ShortHop : public CDOTA_Buff
{
	float32 jump_duration;
	int32 jump_height;
	int32 jump_horizontal_distance;
	float32 pre_land_anim_time;
	float32 landing_gesture_duration;
	float32 impact_radius;
	int32 impact_damage;
	float32 impact_stun_duration;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flJumpDuration;
	float32 m_flJumpHeight;
	Vector m_vTargetHorizontalDirection;
};
