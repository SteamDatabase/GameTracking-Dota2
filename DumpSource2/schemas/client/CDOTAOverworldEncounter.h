// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MVDataRoot
class CDOTAOverworldEncounter
{
	CUtlString m_sName;
	CUtlString m_sTemplate;
	CUtlString m_sLocName;
	CUtlString m_sLocDescription;
	CPanoramaImageName m_sImage;
	EOverworldEncounterRewardStyle m_eRewardStyle;
	CUtlVector< CDOTAOverworldEncounterReward > m_vecRewards;
	CUtlString m_sDefaultDialogue;
	KeyValues3 m_kvCustomData;
	bool m_bRequiresNodeToBeUnlockedToClaimRewards;
	int32 m_nLeaderboardCount;
};
