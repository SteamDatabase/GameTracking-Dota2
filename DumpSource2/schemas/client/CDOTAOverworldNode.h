class CDOTAOverworldNode
{
	OverworldNodeID_t m_unID;
	Vector2D m_vPos;
	CUtlString m_sCustomClass;
	CUtlString m_sDialogueName;
	CUtlString m_sRewardEventAction;
	CUtlString m_sHiddenWithoutEventAction;
	CUtlString m_sJSEvent;
	float32 m_flUnlockDelay;
	bool m_bSkipGrantingRewardOnUnlock;
	EOverworldNodeFlags m_eNodeFlags;
	CUtlString m_sEncounterName;
	CUtlVector< CUtlString > m_vecUnlockMapClasses;
	CUtlVector< CUtlString > m_vecVisitMapClasses;
};
