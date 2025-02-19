class C_DOTAWorldParticleSystem
{
	int32 m_nType;
	ParticleIndex_t m_iClientEffectIndex;
	CUtlSymbolLarge m_szEffectName;
	CUtlSymbolLarge m_szTargetName;
	CUtlSymbolLarge m_szControlPoint;
	HSequence m_hOverrideSequence;
	CStrongHandle< InfoForResourceTypeCModel > m_hOverrideModel;
	Vector m_vModelScale;
	int32 m_nSkinOverride;
	bool m_bDayTime;
	bool m_bNightTime;
	bool m_bShowInFow;
	bool m_bShowWhileDynamicWeatherActive;
	bool m_bAnimateDuringGameplayPause;
};
