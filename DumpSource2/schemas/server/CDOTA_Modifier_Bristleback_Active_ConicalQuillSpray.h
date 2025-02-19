class CDOTA_Modifier_Bristleback_Active_ConicalQuillSpray
{
	int32 activation_num_quill_sprays;
	float32 activation_spray_interval;
	int32 activation_angle;
	int32 cast_range_bonus;
	int32 activation_movement_speed_pct;
	int32 activation_turn_rate_pct;
	int32 activation_disable_turning;
	int32 activation_ignore_cast_angle;
	int32 activation_turn_rate;
	float32 activation_delay;
	GameTime_t m_fStartTime;
	bool bDelayFinished;
	float32 m_flFacingTarget;
	Vector m_vFacing;
	int32 m_nNumSprays;
};
