class C_DOTA_PortraitEntity : public C_DOTA_BaseNPC
{
	CountdownTimer m_PetIdleTimer;
	ParticleIndex_t m_nMouthFX;
	int32 m_nMouthControlPoint;
	ParticleIndex_t m_iPortraitParticle;
	int32 m_PortraitActivity;
	CUtlVector< CUtlSymbol > m_CustomActivityModifiers;
	bool m_bIsSimulationActive;
	CEntityHandle m_hAppearanceFromNPC;
};
