// MNetworkExcludeByName = "m_angRotation"
// MNetworkExcludeByName = "m_angRotation[0]"
// MNetworkExcludeByName = "m_angRotation[1]"
// MNetworkVarNames = "int m_iDamageLevel"
// MNetworkVarNames = "HParticleSystemDefinitionStrong m_nFXIndex"
// MNetworkVarNames = "HParticleSystemDefinitionStrong m_nFXIndexDestruction"
// MNetworkVarNames = "QAngle m_angInitialAngles"
// MNetworkVarNames = "HSequence m_hHeroStatueSequence"
// MNetworkVarNames = "HSequence m_hConstantLayerSequence"
// MNetworkVarNames = "float m_fHeroStatueCycle"
// MNetworkVarNames = "int m_iHeroStatueStatusEffectIndex"
// MNetworkVarNames = "bool m_bHeroStatue"
// MNetworkVarNames = "bool m_bBattleCup"
// MNetworkVarNames = "char m_HeroStatueInscription"
// MNetworkVarNames = "PlayerID_t m_iHeroStatueOwnerPlayerID"
// MNetworkVarNames = "Color m_ParticleTintColor"
// MNetworkVarNames = "FowCustomTeams_t m_nFoWTeam"
class CDOTA_BaseNPC_Building : public CDOTA_BaseNPC
{
	// MNetworkEnable
	int32 m_iDamageLevel;
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
	CUtlSymbolLarge m_sDestroySnd;
	CUtlSymbolLarge m_sDmgLvl1Snd;
	CUtlSymbolLarge m_sDmgLvl2Snd;
	CUtlSymbolLarge m_iszLinkedUnit;
	CUtlSymbolLarge m_iszAmbientEffectName;
	CUtlSymbolLarge m_iszDestructionEffectName;
	CUtlSymbolLarge m_iszDamageModelLevel1;
	CUtlSymbolLarge m_iszDamageModelLevel2;
	CUtlSymbolLarge m_iszDamageEffectLevel1;
	CUtlSymbolLarge m_iszDamageEffectLevel2;
	float32 m_flDamageThresholdLevel1;
	float32 m_flDamageThresholdLevel2;
	bool m_bVulnerableOnCreepSpawn;
	bool m_bHasOverriddenDestructionEffect;
	int32 m_iUpgradeIdentifier;
	int32 m_iInvulnCount;
	int32 m_iPlayerOwner;
	bool m_bIsDireSide;
	DOTA_LANE m_Lane;
	float32[2] m_fAmountAlongLane;
	Vector m_vOverrideInitialAngles;
	Vector m_vOverrideInitialAnglesBG;
	int32 m_nOverrideInitialAngles;
	CountdownTimer m_IdleRareAnimationTime;
	// MNetworkEnable
	FowCustomTeams_t m_nFoWTeam;
};
