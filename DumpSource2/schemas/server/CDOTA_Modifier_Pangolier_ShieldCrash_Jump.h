class CDOTA_Modifier_Pangolier_ShieldCrash_Jump : public CDOTA_Buff
{
	float32 jump_duration;
	float32 jump_duration_gyroshell;
	int32 jump_height;
	int32 jump_height_gyroshell;
	float32 m_flStartZ;
	float32 m_flCurTime;
	float32 m_flJumpDuration;
	float32 m_flJumpHeight;
	int32 jump_horizontal_distance;
	Vector m_vTargetHorizontalDirection;
	float32 m_flPreviousElapsedTime;
};
