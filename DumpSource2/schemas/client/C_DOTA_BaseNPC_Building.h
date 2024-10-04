class C_DOTA_BaseNPC_Building : public C_DOTA_BaseNPC
{
	int32 m_iDamageLevel;
	ParticleIndex_t m_nAmbientFXIndex;
	ParticleIndex_t m_nTPFXIndex;
	ParticleIndex_t m_nStatusFXIndex;
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_nFXIndex;
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_nFXIndexDestruction;
	QAngle m_angInitialAngles;
	HSequence m_hHeroStatueSequence;
	HSequence m_hConstantLayerSequence;
	float32 m_fHeroStatueCycle;
	int32 m_iHeroStatueStatusEffectIndex;
	bool m_bHeroStatue;
	bool m_bBattleCup;
	char[32] m_HeroStatueInscription;
	PlayerID_t m_iHeroStatueOwnerPlayerID;
	Color m_ParticleTintColor;
	FowCustomTeams_t m_nFoWTeam;
};
