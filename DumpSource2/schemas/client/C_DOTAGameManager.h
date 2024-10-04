class C_DOTAGameManager
{
	CNetworkVarChainer __m_pChainEntity;
	bool m_bCustomGame;
	bool m_bEventGame;
	bool m_bGameModeWantsDefaultNeutralItemSchema;
	bool m_bGameModeFilteredAbilities;
	char[128] m_szAddOnGame;
	char[128] m_szAddOnMap;
	KeyValues* m_pTutorialLessonKeyValues;
	KeyValues* m_pDivisionKeyValues;
	KeyValues* m_pMatchGroupsKeyValues;
	KeyValues* m_pAnimationStatues;
	KeyValues* m_pBotScriptsDedicatedServer;
	KeyValues* m_pkvWardPlacementLocations;
	KeyValues* m_pRegionKeyValues;
	KeyValues* m_pSurveyQuestionData;
	KeyValues3 m_AddonInfoKeyValues;
	KeyValues* m_pCountryKeyValues;
	bool[9] m_bLoadedPortraits;
	KeyValues* m_pControlGroupsKeyValues;
	bool[256] m_CurrentHeroAvailable;
};
