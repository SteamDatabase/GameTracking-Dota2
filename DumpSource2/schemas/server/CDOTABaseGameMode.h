class CDOTABaseGameMode
{
	CUtlString m_ForcedHUDSkin;
	HeroID_t m_nCustomGameForceHeroSelectionId;
	HeroFacetID_t m_nCustomGameForceHeroVariant;
	bool m_bAlwaysShowPlayerInventory;
	bool m_bGoldSoundDisabled;
	bool m_bRecommendedItemsDisabled;
	bool m_bStickyItemDisabled;
	bool m_bStashPurchasingDisabled;
	bool m_bFogOfWarDisabled;
	bool m_bUseUnseenFOW;
	bool m_bUseCustomBuybackCost;
	bool m_bUseCustomBuybackCooldown;
	bool m_bBuybackEnabled;
	bool m_bUseTurboCouriers;
	float32 m_flCameraDistanceOverride;
	int32 m_nCameraSmoothCountOverride;
	CHandle< CDOTA_BaseNPC > m_hOverrideSelectionEntity;
	bool m_bTopBarTeamValuesOverride;
	bool m_bTopBarTeamValuesVisible;
	int32 m_nTeamGoodGuysTopBarValue;
	int32 m_nTeamBadGuysTopBarValue;
	bool m_bAlwaysShowPlayerNames;
	bool m_bUseCustomHeroLevels;
	CNetworkUtlVectorBase< int32 > m_nCustomXPRequiredToReachNextLevel;
	bool m_bTowerBackdoorProtectionEnabled;
	bool m_bBotThinkingEnabled;
	bool m_bAnnouncerDisabled;
	bool m_bAnnouncerGameModeAnnounceDisabled;
	bool m_bDeathTipsDisabled;
	bool m_bFilterPlayerHeroAvailability;
	bool m_bKillingSpreeAnnouncerDisabled;
	float32 m_flFixedRespawnTime;
	float32 m_flBuybackCostScale;
	float32 m_flRespawnTimeScale;
	bool m_bLoseGoldOnDeath;
	bool m_bKillableTombstones;
	uint32 m_nHUDVisibilityBits;
	float32 m_flMinimumAttackSpeed;
	float32 m_flMaximumAttackSpeed;
	bool m_bIsDaynightCycleDisabled;
	float32 m_flDaynightCycleAdvanceRate;
	bool m_bAreWeatherEffectsDisabled;
	bool m_bDisableHudFlip;
	bool m_bEnableFriendlyBuildingMoveTo;
	bool m_bIsDeathOverlayDisabled;
	bool m_bIsHudCombatEventsDisabled;
	CUtlString m_strDefaultStickyItem;
	CUtlString m_sCustomTerrainWeatherEffect;
	CUtlString m_strTPScrollSlotItemOverride;
	float32 m_flStrengthDamage;
	float32 m_flStrengthHP;
	float32 m_flStrengthHPRegen;
	float32 m_flAgilityDamage;
	float32 m_flAgilityArmor;
	float32 m_flAgilityAttackSpeed;
	float32 m_flAgilityMovementSpeedPercent;
	float32 m_flIntelligenceDamage;
	float32 m_flIntelligenceMana;
	float32 m_flIntelligenceManaRegen;
	float32 m_flIntelligenceMres;
	float32 m_flIntelligenceSpellAmpPercent;
	float32 m_flStrengthMagicResistancePercent;
	float32 m_flAttributeAllDamage;
	float32 m_flDraftingHeroPickSelectTimeOverride;
	float32 m_flDraftingBanningTimeOverride;
	bool m_bPauseEnabled;
	int32 m_iCustomScanMaxCharges;
	float32 m_flCustomScanCooldown;
	float32 m_flCustomGlyphCooldown;
	float32 m_flCustomBackpackSwapCooldown;
	float32 m_flCustomBackpackCooldownPercent;
	bool m_bDefaultRuneSpawnLogic;
	bool m_bEnableFreeCourierMode;
	bool m_bAllowNeutralItemDrops;
	bool m_bEnableNeutralStash;
	bool m_bEnableNeutralStashTeamViewOnly;
	bool m_bEnableNeutralItemHideUndiscovered;
	bool m_bEnableSendToStash;
	bool m_bForceRightClickAttackDisabled;
	CUtlVectorEmbeddedNetworkVar< CDOTACustomShopInfo > m_vecCustomShopInfo;
	bool m_bCanSellAnywhere;
	float32 m_flCameraNearZ;
	float32 m_flCameraFarZ;
	int32 m_nCustomRadiantScore;
	int32 m_nCustomDireScore;
	bool m_bAbilityUpgradeWhitelistEnabled;
	CNetworkUtlVectorBase< AbilityID_t > m_vecAbilityUpgradeWhitelist;
	bool m_bGiveFreeTPOnDeath;
	int32 m_nInnateMeleeDamageBlockPct;
	int32 m_nInnateMeleeDamageBlockAmount;
	int32 m_nInnateMeleeDamageBlockPerLevelAmount;
	float32 m_flWaterRuneSpawnInterval;
	CNetworkUtlVectorBase< CHandle< CDOTA_BaseNPC > > m_vecBigHealthBarUnits;
	bool m_bSelectionGoldPenaltyEnabled;
	bool m_bRemoveIllusionsOnDeath;
	bool m_bRandomHeroBonusItemGrantDisabled;
	bool m_bDisableClumpingBehaviorByDefault;
	bool[10] m_bRuneTypeEnabled;
	bool m_bOverrideBotLateGame;
	bool m_bBotsAlwaysPushWithHuman;
	bool m_bBotsInLateGame;
	int32 m_nBotMaxPushTier;
	float32 m_flFountainPercentageHealthRegen;
	float32 m_flFountainPercentageManaRegen;
	float32 m_flFountainConstantManaRegen;
	float32 m_flPowerRuneSpawnInterval;
	float32 m_flBountyRuneSpawnInterval;
	float32 m_flXPRuneSpawnInterval;
};
