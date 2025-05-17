class CDOTA_Modifier_Morty_Hop : public CDOTA_Buff
{
	Vector m_vStartPosition;
	Vector m_vTargetPosition;
	float32 m_flCurrentTimeHoriz;
	float32 m_flCurrentTimeVert;
	float32 m_flZCoefficientA;
	float32 m_flZCoefficientB;
	bool m_bInterrupted;
	float32 duration;
	int32 height;
	int32 damage;
	int32 damage_radius;
};
