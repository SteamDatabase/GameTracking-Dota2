class CDOTA_Modifier_Spectre_ShadowStep_Illusion : public CDOTA_Buff
{
	int32 radius;
	int32 bonus_move_speed_illusion_pct;
	int32 move_speed;
	float32 duration;
	float32 m_flSpeed;
	CHandle< CBaseEntity > m_hTarget;
	bool m_bReachedTarget;
};
