class CDOTATrophyDefinition
{
	uint16 m_nID;
	bool m_bObtainable;
	bool m_bShowProgressBar;
	bool m_bShowInitialEarn;
	CUtlString m_sCreationDate;
	uint32 m_nBadgePointsPerUnit;
	uint32 m_nUnitsPerBadgePoint;
	uint32 m_nMaxUnitsForBadgePoints;
	uint32 m_nSortTier;
	CUtlString m_sLocCategory;
	CUtlString m_sLocName;
	CUtlString m_sLocDescription;
	CUtlString m_sLocUnitsPluralizable;
	CUtlVector< TrophyLevel_t > m_vecLevels;
};
