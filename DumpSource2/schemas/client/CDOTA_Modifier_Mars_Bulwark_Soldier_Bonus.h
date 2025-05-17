class CDOTA_Modifier_Mars_Bulwark_Soldier_Bonus : public CDOTA_Buff
{
	int32 m_nPoseParameterWE;
	int32 m_nPoseParameterNS;
	float32 m_flLastPoseX;
	float32 m_flLastPoseY;
	int32 m_nLastMaxDirection;
	Vector m_vLastOrigin;
	GameTime_t m_flLastGameTime;
};
