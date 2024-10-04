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
};
