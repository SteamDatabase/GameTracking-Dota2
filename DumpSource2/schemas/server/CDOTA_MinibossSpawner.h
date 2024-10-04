class CDOTA_MinibossSpawner : public CPointEntity
{
	bool m_bIsRadiantMiniboss;
	bool m_bIsMinibossAlive;
	bool m_bSpawnRequested;
	CHandle< CBaseEntity > m_hMiniboss;
	GameTime_t m_fMinibossKillTime;
	int32 m_nSentMinibossReclaim;
	int32 m_nSentMinibossRespawn;
	int32 m_nTimesSpawned;
	float32 m_fMinibossRespawnDuration;
}
