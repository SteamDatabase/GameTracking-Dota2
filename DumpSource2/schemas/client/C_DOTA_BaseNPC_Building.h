// MNetworkExcludeByName = "m_angRotation"
// MNetworkExcludeByName = "m_angRotation[0]"
// MNetworkExcludeByName = "m_angRotation[1]"
// MEntityAllowsPortraitWorldSpawn
// MNetworkVarNames = "int m_iDamageLevel"
class C_DOTA_BaseNPC_Building : public C_DOTA_BaseNPC
{
	// MNetworkEnable
	int32 m_iDamageLevel;
	ParticleIndex_t m_nAmbientFXIndex;
	ParticleIndex_t m_nTPFXIndex;
	ParticleIndex_t m_nStatusFXIndex;
	// MNetworkEnable
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_nFXIndex;
	// MNetworkEnable
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_nFXIndexDestruction;
	// MNetworkEnable
	QAngle m_angInitialAngles;
	// MNetworkEnable
	HSequence m_hHeroStatueSequence;
	// MNetworkEnable
	HSequence m_hConstantLayerSequence;
	// MNetworkEnable
	float32 m_fHeroStatueCycle;
	// MNetworkEnable
	int32 m_iHeroStatueStatusEffectIndex;
	// MNetworkEnable
	bool m_bHeroStatue;
	// MNetworkEnable
	bool m_bBattleCup;
	// MNetworkEnable
	char[32] m_HeroStatueInscription;
	// MNetworkEnable
	PlayerID_t m_iHeroStatueOwnerPlayerID;
	// MNetworkEnable
	Color m_ParticleTintColor;
	// MNetworkEnable
	FowCustomTeams_t m_nFoWTeam;
};
