class CDOTA_Modifier_DarkSeer_Normal_Punch_Illusion_Thinker : public CDOTA_Buff
{
	Vector m_vecIllusionSpawnPosition;
	int32 speed;
	CHandle< C_BaseEntity > m_hTarget;
	ParticleIndex_t m_nFXIndex;
};
