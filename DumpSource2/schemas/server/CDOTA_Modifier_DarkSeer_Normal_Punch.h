class CDOTA_Modifier_DarkSeer_Normal_Punch : public CDOTA_Buff
{
	Vector[30] m_PositionIndex;
	ParticleIndex_t m_nNormalPunchBuffIndex;
	float32 m_flDistanceTraveled;
	bool m_bIsValidTarget;
};
