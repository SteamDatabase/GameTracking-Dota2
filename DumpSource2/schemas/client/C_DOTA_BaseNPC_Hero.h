// MNetworkVarNames = "int m_iCurrentXP"
// MNetworkVarNames = "int m_iAbilityPoints"
// MNetworkVarNames = "int m_iTotalAbilityPoints"
// MNetworkVarNames = "GameTime_t m_flRespawnTime"
// MNetworkVarNames = "float m_flRespawnTimePenalty"
// MNetworkVarNames = "float m_flStrength"
// MNetworkVarNames = "float m_flAgility"
// MNetworkVarNames = "float m_flIntellect"
// MNetworkVarNames = "float m_flStrengthTotal"
// MNetworkVarNames = "float m_flAgilityTotal"
// MNetworkVarNames = "float m_flIntellectTotal"
// MNetworkVarNames = "EHANDLE m_hFacetAbilities"
// MNetworkVarNames = "int m_vecHiddenLoadoutSlots"
// MNetworkVarNames = "int m_iRecentDamage"
// MNetworkVarNames = "PlayerID_t m_iPlayerID"
// MNetworkVarNames = "HeroFacetKey_t m_iHeroFacetKey"
// MNetworkVarNames = "CHandle<C_DOTA_BaseNPC_Hero> m_hReplicatingOtherHeroModel"
// MNetworkVarNames = "bool m_bReincarnating"
// MNetworkVarNames = "bool m_bCustomKillEffect"
// MNetworkVarNames = "GameTime_t m_flSpawnedAt"
// MNetworkVarNames = "bool m_bScriptDisableRespawns"
// MNetworkVarNames = "int m_iPrimaryAttribute"
// MNetworkVarNames = "GameTime_t m_flLastDispellTime"
// MNetworkIncludeByName = "m_flDeathTime"
class C_DOTA_BaseNPC_Hero : public C_DOTA_BaseNPC_Additive
{
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iCurrentXP;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnAbilityPointsChanged"
	int32 m_iAbilityPoints;
	// MNetworkEnable
	int32 m_iTotalAbilityPoints;
	// MNetworkEnable
	GameTime_t m_flRespawnTime;
	// MNetworkEnable
	float32 m_flRespawnTimePenalty;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBaseStatChanged"
	float32 m_flStrength;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBaseStatChanged"
	float32 m_flAgility;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBaseStatChanged"
	float32 m_flIntellect;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBaseStatChanged"
	float32 m_flStrengthTotal;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBaseStatChanged"
	float32 m_flAgilityTotal;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBaseStatChanged"
	float32 m_flIntellectTotal;
	// MNetworkEnable
	C_NetworkUtlVectorBase< CHandle< C_BaseEntity > > m_hFacetAbilities;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnHiddenLoadoutSlotsChanged"
	C_NetworkUtlVectorBase< int32 > m_vecHiddenLoadoutSlots;
	// MNetworkEnable
	int32 m_iRecentDamage;
	float32 m_fPainFactor;
	float32 m_fTargetPainFactor;
	bool m_bLifeState;
	bool m_bFirstSpawn;
	ParticleIndex_t m_nFXStunIndex;
	ParticleIndex_t m_nFXSilenceIndex;
	ParticleIndex_t m_nFXDeathIndex;
	// MNetworkEnable
	PlayerID_t m_iPlayerID;
	// MNetworkEnable
	HeroFacetKey_t m_iHeroFacetKey;
	// MNetworkEnable
	CHandle< C_DOTA_BaseNPC_Hero > m_hReplicatingOtherHeroModel;
	// MNetworkEnable
	bool m_bReincarnating;
	// MNetworkEnable
	bool m_bCustomKillEffect;
	// MNetworkEnable
	GameTime_t m_flSpawnedAt;
	// MNetworkEnable
	bool m_bScriptDisableRespawns;
	// MNetworkEnable
	int32 m_iPrimaryAttribute;
	int32 m_nLastDrawnHealth;
	float32 m_flHurtAmount;
	GameTime_t m_flLastHurtTime;
	float32 m_flHurtDecayRate;
	float32 m_flHealAmount;
	GameTime_t m_flLastHealTime;
	float32 m_flHealDecayRate;
	bool m_bIsFirstTimeHeal;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnLastDispellTimeChanged"
	GameTime_t m_flLastDispellTime;
	float32 m_flDispellAnimationAmount;
	float32 m_flDeathAnimationAmount;
	GameTime_t m_flLastDeathTime;
	GameTime_t m_flLastTreeShakeTime;
	CountdownTimer m_CenterOnHeroCooldownTimer;
	CStrongHandle< InfoForResourceTypeCModel >[4] m_CombinedModels;
	int32 m_nCurrentCombinedModelIndex;
	int32 m_nPendingCombinedModelIndex;
	HeroID_t m_iHeroID;
	float32 m_flCheckLegacyItemsAt;
	bool m_bDisplayAdditionalHeroes;
	CStrongHandle< InfoForResourceTypeCModel >[4] m_CombinedParticleModels;
	CUtlVector< ParticleIndex_t > m_vecAttachedParticleIndeces;
	CUtlVector< CHandle< C_BaseEntity > > m_hPets;
	ParticleIndex_t m_nKillStreakFX;
	int32 m_nKillStreakFXTier;
	bitfield:1 m_bBuybackDisabled;
	bitfield:1 m_bWasFrozen;
	bitfield:1 m_bUpdateClientsideWearables;
	bitfield:1 m_bForceBuildCombinedModel;
	bitfield:1 m_bRecombineForMaterialsOnly;
	bitfield:1 m_bBuildingCombinedModel;
	bitfield:1 m_bInReloadEvent;
	bitfield:1 m_bStoreOldVisibility;
	bitfield:1 m_bResetVisibility;
	bitfield:1 m_bStoredVisibility;
};
