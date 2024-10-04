class CDOTA_Modifier_Lich_Ice_Spire : public CDOTA_Buff
{
	float32 aura_radius;
	ParticleIndex_t m_nFXIndex;
	CountdownTimer m_Timer;
	bool has_aura;
	CHandle< C_BaseEntity > hVictim;
}
