// MNetworkVarNames = "DOTAThreatLevelInfo_t m_ThreatLevelInfos"
// MNetworkVarNames = "HeroID_t m_nSelectedHeroID"
// MNetworkVarNames = "HeroFacetID_t m_nSelectedHeroVariant"
// MNetworkVarNames = "int m_iKills"
// MNetworkVarNames = "int m_iAssists"
// MNetworkVarNames = "int m_iDeaths"
// MNetworkVarNames = "int m_iStreak"
// MNetworkVarNames = "int m_iLevel"
// MNetworkVarNames = "int m_iCustomIntParam"
// MNetworkVarNames = "int m_iRespawnSeconds"
// MNetworkVarNames = "GameTime_t m_flLastBuybackTime"
// MNetworkVarNames = "int m_iLastBuybackTime_Obsolete"
// MNetworkVarNames = "EHANDLE m_hSelectedHero"
// MNetworkVarNames = "bool m_bAFK"
// MNetworkVarNames = "HeroID_t m_nSuggestedHeroes"
// MNetworkVarNames = "bool m_bBanSuggestedHeroes"
// MNetworkVarNames = "uint16 m_unCompendiumLevel"
// MNetworkVarNames = "bool m_bCanRepick"
// MNetworkVarNames = "bool m_bCanEarnRewards"
// MNetworkVarNames = "bool m_bHasRandomed"
// MNetworkVarNames = "HeroID_t m_nRandomedHeroID"
// MNetworkVarNames = "bool m_bBattleBonusActive"
// MNetworkVarNames = "uint16 m_iBattleBonusRate"
// MNetworkVarNames = "int m_iCustomBuybackCost"
// MNetworkVarNames = "Color m_CustomPlayerColor"
// MNetworkVarNames = "bool m_bQualifiesForPAContractReward"
// MNetworkVarNames = "bool m_bHasPredictedVictory"
// MNetworkVarNames = "UnitShareMask_t m_UnitShareMasks"
// MNetworkVarNames = "int m_iTeamSlot"
// MNetworkVarNames = "uint8 m_iBattleCupWinStreak"
// MNetworkVarNames = "uint64 m_iBattleCupWinDate"
// MNetworkVarNames = "uint16 m_iBattleCupSkillLevel"
// MNetworkVarNames = "uint32 m_iBattleCupTeamID"
// MNetworkVarNames = "uint32 m_iBattleCupTournamentID"
// MNetworkVarNames = "uint8 m_iBattleCupDivision"
// MNetworkVarNames = "float m_flTeamFightParticipation"
// MNetworkVarNames = "int m_iFirstBloodClaimed"
// MNetworkVarNames = "int m_iFirstBloodGiven"
// MNetworkVarNames = "uint32 m_unPickOrder"
// MNetworkVarNames = "GameTime_t m_flTimeOfLastSaluteSent"
// MNetworkVarNames = "PlayerResourcePlayerEventData_t m_vecPlayerEventData"
// MNetworkVarNames = "uint32 m_unSelectedHeroBadgeXP"
// MNetworkVarNames = "uint8 m_iBountyRunes"
// MNetworkVarNames = "uint8 m_iPowerRunes"
// MNetworkVarNames = "uint8 m_iWaterRunes"
// MNetworkVarNames = "uint8 m_iOutpostsCaptured"
// MNetworkVarNames = "uint8 m_unGuildTier"
// MNetworkVarNames = "uint16 m_unGuildLevel"
// MNetworkVarNames = "uint8 m_unGuildPrimaryColor"
// MNetworkVarNames = "uint8 m_unGuildSecondaryColor"
// MNetworkVarNames = "uint8 m_unGuildPattern"
// MNetworkVarNames = "uint64 m_unGuildLogo"
// MNetworkVarNames = "uint32 m_unGuildFlags"
// MNetworkVarNames = "bool m_bIsPartyGuild"
// MNetworkVarNames = "GuildID_t m_unGuildID"
// MNetworkVarNames = "item_definition_index_t m_unHeroStickerDefIndex"
// MNetworkVarNames = "uint8 m_eHeroStickerQuality"
// MNetworkVarNames = "uint8 m_eLaneSelectionFlags"
// MNetworkVarNames = "uint8 m_nPlayerDraftPreferredRoles"
// MNetworkVarNames = "int8 m_nPlayerDraftPreferredTeam"
// MNetworkVarNames = "uint8 m_nAvailableGifts"
// MNetworkVarNames = "uint8 m_unFowTeam"
// MNetworkVarNames = "AbilityID_t m_vecItemPreferenceLiked"
// MNetworkVarNames = "AbilityID_t m_vecItemPreferenceDisliked"
// MNetworkVarNames = "uint32 m_iObsoleteEventPoints"
// MNetworkVarNames = "uint32 m_iObsoleteEventPremiumPoints"
// MNetworkVarNames = "uint32 m_iObsoleteEventWagerTokensRemaining"
// MNetworkVarNames = "uint32 m_iObsoleteEventWagerTokensMax"
// MNetworkVarNames = "uint32 m_iObsoleteEventEffectsMask"
// MNetworkVarNames = "uint16 m_iObsoleteEventRanks"
// MNetworkVarNames = "bool m_bObsoleteIsEventOwned"
// MNetworkVarNames = "uint32 m_iObsoleteRankWagersAvailable"
// MNetworkVarNames = "uint32 m_iObsoleteRankWagersMax"
// MNetworkVarNames = "uint32 m_iObsoleteEventPointAdjustmentsRemaining"
// MNetworkVarNames = "uint32 m_iObsoleteAvailableSalutes"
// MNetworkVarNames = "uint32 m_iObsoleteSaluteAmounts"
class PlayerResourcePlayerTeamData_t
{
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< DOTAThreatLevelInfo_t > m_ThreatLevelInfos;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerTeamDataSelectionDirty"
	HeroID_t m_nSelectedHeroID;
	// MNetworkEnable
	HeroFacetID_t m_nSelectedHeroVariant;
	// MNetworkEnable
	int32 m_iKills;
	// MNetworkEnable
	int32 m_iAssists;
	// MNetworkEnable
	int32 m_iDeaths;
	// MNetworkEnable
	int32 m_iStreak;
	// MNetworkEnable
	int32 m_iLevel;
	// MNetworkEnable
	int32 m_iCustomIntParam;
	// MNetworkEnable
	int32 m_iRespawnSeconds;
	// MNetworkEnable
	GameTime_t m_flLastBuybackTime;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnLastBuybackTimeChanged"
	int32 m_iLastBuybackTime_Obsolete;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hSelectedHero;
	// MNetworkEnable
	bool m_bAFK;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerTeamDataSelectionDirty"
	HeroID_t[4] m_nSuggestedHeroes;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerTeamDataSelectionDirty"
	bool[4] m_bBanSuggestedHeroes;
	// MNetworkEnable
	uint16 m_unCompendiumLevel;
	// MNetworkEnable
	bool m_bCanRepick;
	// MNetworkEnable
	bool m_bCanEarnRewards;
	// MNetworkEnable
	bool m_bHasRandomed;
	// MNetworkEnable
	HeroID_t m_nRandomedHeroID;
	// MNetworkEnable
	bool m_bBattleBonusActive;
	// MNetworkEnable
	uint16 m_iBattleBonusRate;
	// MNetworkEnable
	int32 m_iCustomBuybackCost;
	// MNetworkEnable
	Color m_CustomPlayerColor;
	// MNetworkEnable
	bool m_bQualifiesForPAContractReward;
	// MNetworkEnable
	bool m_bHasPredictedVictory;
	// MNetworkEnable
	int32 m_UnitShareMasks;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerTeamDataTeamChanged"
	int32 m_iTeamSlot;
	// MNetworkEnable
	uint8 m_iBattleCupWinStreak;
	// MNetworkEnable
	uint64 m_iBattleCupWinDate;
	// MNetworkEnable
	uint16 m_iBattleCupSkillLevel;
	// MNetworkEnable
	uint32 m_iBattleCupTeamID;
	// MNetworkEnable
	uint32 m_iBattleCupTournamentID;
	// MNetworkEnable
	uint8 m_iBattleCupDivision;
	// MNetworkEnable
	float32 m_flTeamFightParticipation;
	// MNetworkEnable
	int32 m_iFirstBloodClaimed;
	// MNetworkEnable
	int32 m_iFirstBloodGiven;
	// MNetworkEnable
	uint32 m_unPickOrder;
	// MNetworkEnable
	GameTime_t m_flTimeOfLastSaluteSent;
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< PlayerResourcePlayerEventData_t > m_vecPlayerEventData;
	// MNetworkEnable
	uint32 m_unSelectedHeroBadgeXP;
	// MNetworkEnable
	uint8 m_iBountyRunes;
	// MNetworkEnable
	uint8 m_iPowerRunes;
	// MNetworkEnable
	uint8 m_iWaterRunes;
	// MNetworkEnable
	uint8 m_iOutpostsCaptured;
	// MNetworkEnable
	uint8 m_unGuildTier;
	// MNetworkEnable
	uint16 m_unGuildLevel;
	// MNetworkEnable
	uint8 m_unGuildPrimaryColor;
	// MNetworkEnable
	uint8 m_unGuildSecondaryColor;
	// MNetworkEnable
	uint8 m_unGuildPattern;
	// MNetworkEnable
	uint64 m_unGuildLogo;
	// MNetworkEnable
	uint32 m_unGuildFlags;
	// MNetworkEnable
	bool m_bIsPartyGuild;
	// MNetworkEnable
	GuildID_t m_unGuildID;
	// MNetworkEnable
	item_definition_index_t m_unHeroStickerDefIndex;
	// MNetworkEnable
	uint8 m_eHeroStickerQuality;
	// MNetworkEnable
	uint8 m_eLaneSelectionFlags;
	// MNetworkEnable
	uint8 m_nPlayerDraftPreferredRoles;
	// MNetworkEnable
	int8 m_nPlayerDraftPreferredTeam;
	// MNetworkEnable
	uint8 m_nAvailableGifts;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPlayerTeamDataTeamFoWChanged"
	uint8 m_unFowTeam;
	// MNetworkEnable
	C_NetworkUtlVectorBase< AbilityID_t > m_vecItemPreferenceLiked;
	// MNetworkEnable
	C_NetworkUtlVectorBase< AbilityID_t > m_vecItemPreferenceDisliked;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventPoints"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteEventPoints;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventPremiumPoints"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteEventPremiumPoints;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventWagerTokensRemaining"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteEventWagerTokensRemaining;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventWagerTokensMax"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteEventWagerTokensMax;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventEffectsMask"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteEventEffectsMask;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventRanks"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint16 m_iObsoleteEventRanks;
	// MNetworkEnable
	// MNetworkAlias = "m_bIsEventOwned"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	bool m_bObsoleteIsEventOwned;
	// MNetworkEnable
	// MNetworkAlias = "m_iRankWagersAvailable"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteRankWagersAvailable;
	// MNetworkEnable
	// MNetworkAlias = "m_iRankWagersMax"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteRankWagersMax;
	// MNetworkEnable
	// MNetworkAlias = "m_iEventPointAdjustmentsRemaining"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteEventPointAdjustmentsRemaining;
	// MNetworkEnable
	// MNetworkAlias = "m_iAvailableSalutes"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteAvailableSalutes;
	// MNetworkEnable
	// MNetworkAlias = "m_iSaluteAmounts"
	// MNetworkChangeCallback = "OnObsoleteEvent"
	uint32 m_iObsoleteSaluteAmounts;
};
