class CDOTA_Modifier_Mars_Bulwark_Active : public CDOTA_Buff
{
	int32 redirect_chance;
	float32 redirect_range;
	float32 forward_angle;
	float32 side_angle;
	float32 redirect_speed_penatly;
	float32 redirect_close_range;
	int32 attack_redirection_grace_distance;
	int32 m_nPoseParameterWE;
	int32 m_nPoseParameterNS;
	float32 m_flLastPoseX;
	float32 m_flLastPoseY;
	int32 m_nLastMaxDirection;
	Vector m_vLastOrigin;
	GameTime_t m_flLastGameTime;
};
