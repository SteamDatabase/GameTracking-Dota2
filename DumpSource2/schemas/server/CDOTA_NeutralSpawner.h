// MNetworkVarNames = "int m_Type"
class CDOTA_NeutralSpawner : public CPointEntity
{
	bool m_bGameStarted;
	bool m_bFirstSpawn;
	CountdownTimer m_SpawnTimer;
	int32 m_iNextSpawnType;
	int32 m_iMinSpawnType;
	int32 m_iMaxSpawnType;
	int32 m_iSpawnSubtype;
	int32 m_iPreviousSpawnType;
	int32 m_iTotalToSpawn;
	int32 m_iForcedSpawnType;
	int32 m_iNumBatchesToSpawn;
	int32 m_iMaxUpgradeCount;
	int32 m_iCurrentUpgradeCount;
	int32 m_iBaseType;
	bool m_bLimitedBatches;
	PlayerID_t m_iStackingCreditPlayerID;
	float32 m_fInternalSpawnTimerTime;
	CountdownTimer m_InternalSpawnTimer;
	CountdownTimer m_FXTimer;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_PendingUnits;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_Units;
	int32 m_iNextTypeUnitCount;
	bool[2] m_bSeenClearedByTeam;
	CUtlSymbolLarge m_szVolumeName;
	CUtlVector< CHandle< CBaseEntity > > m_hVolumes;
	CEntityIOOutput m_OnSpawnerExhausted;
	// MNetworkEnable
	int32 m_Type;
	int32 m_PullType;
	int32 m_AggroType;
};
