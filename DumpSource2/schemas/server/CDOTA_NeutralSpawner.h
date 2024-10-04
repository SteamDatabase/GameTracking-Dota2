class CDOTA_NeutralSpawner : public CPointEntity
{
	bool m_bGameStarted;
	bool m_bFirstSpawn;
	CountdownTimer m_SpawnTimer;
	int32 m_iNextSpawnType;
	int32 m_iPreviousSpawnType;
	int32 m_iTotalToSpawn;
	int32 m_iForcedSpawnType;
	int32 m_iNumBatchesToSpawn;
	bool m_bLimitedBatches;
	PlayerID_t m_iStackingCreditPlayerID;
	float32 m_fInternalSpawnTimerTime;
	CountdownTimer m_InternalSpawnTimer;
	CountdownTimer m_FXTimer;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_PendingUnits;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_Units;
	bool[2] m_bSeenClearedByTeam;
	CUtlSymbolLarge m_szVolumeName;
	CUtlVector< CHandle< CBaseEntity > > m_hVolumes;
	CEntityIOOutput m_OnSpawnerExhausted;
	int32 m_Type;
	int32 m_PullType;
	int32 m_AggroType;
}
