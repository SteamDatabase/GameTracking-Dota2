class CDOTA_RoshanSpawner
{
	bool m_bIsRoshanAlive;
	bool m_bSpawnRequested;
	GameTime_t m_fRoshanKillTime;
	int32 m_nSentRoshReclaim;
	int32 m_nSentRoshRespawn;
	float32 m_fRoshanRespawnDuration;
	int32 m_iLastKillerTeam;
	int32 m_iKillCount;
	CHandle< CBaseEntity > m_hRoshan;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndex2;
};
