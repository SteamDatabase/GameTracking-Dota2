class CDOTATurboGameMode
{
	int32 m_nHighestLevelInCurrentGame;
	CUtlVector< float32 > m_ExtraMeleeCreepTimes;
	CUtlVector< float32 > m_ExtraRangedCreepTimes;
	CUtlVector< float32 > m_ExtraSiegeCreepTimes;
	int32 m_nExtraGoldPerWave;
	int32 m_nExtraXPPerWave;
	float32 m_flNextRewardDistributionTime;
	float32 m_flNextWaveRecalculationTime;
	bool m_bInOvertime;
	bool m_bDistributingPassiveGoldAndXp;
};
