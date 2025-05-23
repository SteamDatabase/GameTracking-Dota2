class CDOTA_Modifier_Invoker_IceWall_Thinker : public CDOTA_Buff
{
	float32 damage_per_second;
	Vector m_vWallDirection;
	Vector m_vWallStart;
	int32 wall_total_length;
	int32 wall_width;
	float32 slow_duration;
	int32 slow;
	float32 root_damage;
	float32 root_duration;
	float32 tick_interval;
};
