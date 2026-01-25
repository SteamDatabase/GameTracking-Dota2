class CDOTA_NPCSpawner : public CPointEntity
{
	CUtlSymbolLarge m_szNPCScriptName;
	CUtlSymbolLarge m_szNPCName;
	CUtlSymbolLarge m_szNPCFirstWaypoint;
	CountdownTimer m_SpawnTimer;
	CountdownTimer m_IntervalTimer;
	int32 m_iTeam;
	int32 m_iUpgradeMelee;
	int32 m_iUpgradeRange;
	int32 m_iMeleeCount;
	int32 m_iSiegeCount;
	int32 m_iRangeCount;
	int32 m_iWaves;
	bool m_bFirstWave;
	bool m_bShouldSpawnStrongCreep;
	bool m_bEnabled;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_Units;
};
