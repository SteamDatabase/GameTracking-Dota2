class CDOTA_Modifier_Bane_Nightmare : public CDOTA_Buff
{
	int32 m_nSource;
	float32 animation_rate;
	Vector m_vWalkDir;
	int32 walk_speed;
	float32 turn_rate;
	GameTime_t m_flLastThinkTime;
	float32 m_flWalkAngle;
}
