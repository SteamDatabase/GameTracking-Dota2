// MNetworkVarNames = "float m_flStrength"
// MNetworkVarNames = "float m_flAgility"
// MNetworkVarNames = "float m_flIntellect"
// MNetworkVarNames = "float m_flStrengthTotal"
// MNetworkVarNames = "float m_flAgilityTotal"
// MNetworkVarNames = "float m_flIntellectTotal"
// MNetworkVarNames = "int m_iRecentDamage"
// MNetworkVarNames = "int m_iPrimaryAttribute"
// MNetworkVarNames = "GameTime_t m_flDeathTime"
// MNetworkVarNames = "GameTime_t m_flLastDispellTime"
// MNetworkVarNames = "int m_iAbilityPoints"
// MNetworkVarNames = "int m_iTotalAbilityPoints"
// MNetworkVarNames = "int m_iCurrentXP"
// MNetworkVarNames = "GameTime_t m_flRespawnTime"
// MNetworkVarNames = "float m_flRespawnTimePenalty"
// MNetworkVarNames = "bool m_bScriptDisableRespawns"
// MNetworkVarNames = "PlayerID_t m_iPlayerID"
// MNetworkVarNames = "HeroFacetKey_t m_iHeroFacetKey"
// MNetworkVarNames = "CHandle< CDOTA_BaseNPC_Hero> m_hReplicatingOtherHeroModel"
// MNetworkVarNames = "bool m_bReincarnating"
// MNetworkVarNames = "bool m_bCustomKillEffect"
// MNetworkVarNames = "GameTime_t m_flSpawnedAt"
// MNetworkVarNames = "EHANDLE m_hFacetAbilities"
// MNetworkVarNames = "int m_vecHiddenLoadoutSlots"
class CDOTA_BaseNPC_Hero : public CDOTA_BaseNPC_Additive
{
	// MNetworkEnable
	float32 m_flStrength;
	// MNetworkEnable
	float32 m_flAgility;
	// MNetworkEnable
	float32 m_flIntellect;
	// MNetworkEnable
	float32 m_flStrengthTotal;
	// MNetworkEnable
	float32 m_flAgilityTotal;
	// MNetworkEnable
	float32 m_flIntellectTotal;
	// MNetworkEnable
	int32 m_iRecentDamage;
	// MNetworkEnable
	int32 m_iPrimaryAttribute;
	// MNetworkEnable
	GameTime_t m_flDeathTime;
	// MNetworkEnable
	GameTime_t m_flLastDispellTime;
	float32 m_flStrengthGain;
	float32 m_flAgilityGain;
	float32 m_flIntellectGain;
	float32 m_flLastSuggestionTime;
	bool m_bItemsAddedToLoadout;
	bool m_bPregameItemsAddedToLoadout;
	CHandle< CBaseEntity > m_hNewARDMHero;
	GameTime_t m_fBuybackCooldown;
	GameTime_t m_fBuybackGoldLimit;
	int32 m_nLastHealedAmount;
	float32 m_flLastHealedTime;
	CHandle< CBaseEntity > m_hLastHealEntity;
	Vector m_vRespawnPosition;
	CUtlVector< CDOTA_BaseNPC_Hero::sHeroDamageInfo > m_HeroDamageInfoArray;
	CUtlVector< CDOTA_BaseNPC_Hero::sHeroRecentModifierInfo > m_vecRecentModifiers;
	GameTime_t m_fMostRecentDamageTime;
	// MNetworkEnable
	int32 m_iAbilityPoints;
	// MNetworkEnable
	int32 m_iTotalAbilityPoints;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_iCurrentXP;
	// MNetworkEnable
	GameTime_t m_flRespawnTime;
	// MNetworkEnable
	float32 m_flRespawnTimePenalty;
	float32 m_flTimeUntilRespawn;
	float32 m_flScriptRespawnTime;
	float32 m_flPendingRespawnTime;
	// MNetworkEnable
	bool m_bScriptDisableRespawns;
	// MNetworkEnable
	PlayerID_t m_iPlayerID;
	// MNetworkEnable
	HeroFacetKey_t m_iHeroFacetKey;
	PlayerID_t m_iIllusionOriginalPlayerID;
	HeroID_t m_iHeroID;
	// MNetworkEnable
	CHandle< CDOTA_BaseNPC_Hero > m_hReplicatingOtherHeroModel;
	CountdownTimer m_RespawnMusicTimer;
	CountdownTimer m_HeroKillTimer;
	CountdownTimer m_MultipleHeroKillTimer;
	CountdownTimer m_MultipleLastHitTimer;
	int32 m_iMultipleKillCount;
	float32 m_flKillStreakStartTime;
	bool m_bDisableWearables;
	CHandle< CDOTAWearableItem >[103] m_hTogglableWearable;
	CDOTA_BaseNPC_Hero::KillInfo_t m_KillInfo;
	CountdownTimer m_DirectorAbilityActivity;
	// MNetworkEnable
	bool m_bReincarnating;
	// MNetworkEnable
	bool m_bCustomKillEffect;
	// MNetworkEnable
	GameTime_t m_flSpawnedAt;
	// MNetworkEnable
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_hFacetAbilities;
	// MNetworkEnable
	CNetworkUtlVectorBase< int32 > m_vecHiddenLoadoutSlots;
	CountdownTimer m_PurchaseItemTimer;
	CountdownTimer m_NeutralItemTimer;
	CountdownTimer m_RetrieveItemsFromStashTimer;
	CountdownTimer m_RequestGoToSecretShopTimer;
	int32 m_iNextItemToPurchase;
	bool m_bDoesNextItemCompleteRecipe;
	CUtlVector< sLoadoutItem > m_Loadout;
	CUtlVector< std::pair< AbilityID_t, bool > > m_BuildingOrBuilt;
	sLoadoutItem m_TPScroll;
	sLoadoutItem m_Dust;
	sLoadoutItem m_Gem;
	sLoadoutItem m_SentryWard;
	sLoadoutItem m_ObserverWard;
	bool m_bAutoPurchaseItems;
	bool m_bBuybackDisabled;
	CUtlVector< CHandle< CDOTA_BaseNPC_Pet > > m_hPets;
	bool m_bPreventPetSpawn;
	CDOTAMusicProbabilityEntry m_MusicProbabilityGank;
	CUtlString m_strCustomKillEffect;
	CUtlString m_strCustomHexModel;
	ParticleIndex_t m_nKillStreakFX;
	CUtlVector< sAcquireHistory > m_vecItemPurchaseHistory;
	CUtlVector< sAcquireHistory > m_vecAbilitySkillHistory;
	CUtlVector< sAcquireHistory > m_vecNeutralItemEquippedHistory;
	CUtlVector< CHandle< CDOTA_BaseNPC_Hero > > m_vecExpiredIllusions;
	float32 m_flLastTimeLookedAtByDirector;
};
