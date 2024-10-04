class C_PortraitWorldUnit : public C_DOTA_BaseNPC
{
	CEntityIOOutput m_OutputAnimOver;
	bool m_bSuppressIntroEffects;
	bool m_bIsAlternateLoadout;
	bool m_bSkipBackgroundEntities;
	bool m_bSpawnBackgroundModels;
	bool m_bDeferredPortrait;
	bool m_bShowParticleAssetModifiers;
	bool m_bIgnorePortraitInfo;
	bool m_bFlyingCourier;
	bool m_bDisableDefaultModifiers;
	int32 m_nEffigyStatusEffect;
	CUtlSymbolLarge m_effigySequenceName;
	float32 m_flStartingAnimationCycle;
	float32 m_flAnimationPlaybackSpeed;
	float32 m_flRareLoadoutAnimChance;
	bool m_bSetDefaultActivityOnSequenceFinished;
	CUtlVector< CUtlSymbolLarge > m_vecActivityModifiers;
	DOTAPortraitEnvironmentType_t m_environment;
	StartupBehavior_t m_nStartupBehavior;
	CUtlSymbolLarge m_cameraName;
	ParticleIndex_t m_nPortraitParticle;
	int32 m_nCourierType;
};
