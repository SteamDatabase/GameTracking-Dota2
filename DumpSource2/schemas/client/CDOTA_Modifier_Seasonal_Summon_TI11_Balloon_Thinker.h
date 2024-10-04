class CDOTA_Modifier_Seasonal_Summon_TI11_Balloon_Thinker : public CDOTA_Buff
{
	float32 speed;
	int32 min_distance_before_bounce;
	float32 drag;
	float32 max_height;
	float32 max_vertical_move_time;
	float32 bounce_turn_angle;
	float32 bounce_turn_angle_tree;
	float32 bounce_delay;
	int32 max_bounces;
	float32 max_model_scale;
	float32 power_growth_exponent;
	Vector m_vLastPos;
	Vector m_vDir;
	float32 m_flSpeed;
	float32 m_flDistRemaining;
	float32 m_flTreeTimeRemaining;
	int32 m_nTimesBounced;
	float32 m_flModelScale;
	CHandle< C_BaseEntity > m_hLastHit;
};
