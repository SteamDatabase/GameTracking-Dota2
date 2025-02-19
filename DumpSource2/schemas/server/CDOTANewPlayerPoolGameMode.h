class CDOTANewPlayerPoolGameMode
{
	int32 m_nHighestLevelInCurrentGame;
	CUtlVector< float32 > m_ExtraMeleeCreepTimes;
	CUtlVector< float32 > m_ExtraRangedCreepTimes;
	CUtlVector< float32 > m_ExtraSiegeCreepTimes;
	bool m_bInOvertime;
};
