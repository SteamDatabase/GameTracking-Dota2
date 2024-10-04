class CDOTA_Modifier_AghsFort_StonehallGeneral_OverwhelmingOdds_Thinker : public CDOTA_Buff
{
	int32 radius;
	int32 max_steps;
	float32 damage_interval;
	int32 m_nNumSteps;
	int32 m_nRadiusStep;
	ParticleIndex_t m_nFXIndex;
	Vector m_vDir;
};
