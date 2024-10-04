class CDOTA_Modifier_Lich_Ice_Spire_VictimCopy : public CDOTA_Buff
{
	float32 aura_radius;
	ParticleIndex_t m_nFXIndex;
	CountdownTimer m_Timer;
	bool m_bIsHeroSpire;
};
