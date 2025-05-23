class CDOTA_Ability_Invoker_IceWall : public CDOTA_Ability_Invoker_InvokedBase
{
	Vector m_vEndPosition;
	int32 num_wall_elements;
	float32 wall_element_spacing;
	float32 wall_element_radius;
	int32 vector_cast_range;
	int32 slow;
	float32 damage_per_second;
	float32 duration;
	float32 slow_duration;
	float32 root_damage;
	float32 root_duration;
	float32 tick_interval;
	float32 wall_total_length;
	float32 wall_width;
};
