class CDOTALabyrinthBlessingsMap
{
	CUtlString m_strBlessingEventAction;
	BlessingTypeID_t m_nNextBlessingTypeID;
	BlessingID_t m_nNextBlessingID;
	CUtlString m_UnlockHeroBlessingType;
	CUtlVector< CUtlString > m_vecHeroNames;
	int32 m_nNumStartingHeroesUnlocked;
	CUtlString m_UnlockLegacyHeroBlessingType;
	CUtlVector< CUtlString > m_vecLegacyHeroNames;
	int32 m_nNumStartingLegacyHeroesUnlocked;
	CUtlDict< BlessingType_t > m_mapBlessingTypes;
	CUtlDict< Blessing_t > m_mapBlessings;
	CUtlVector< BlessingPath_t > m_vecPaths;
}
