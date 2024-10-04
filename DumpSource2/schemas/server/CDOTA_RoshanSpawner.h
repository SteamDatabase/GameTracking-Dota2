class CDOTA_RoshanSpawner : public CPointEntity
{
	bool m_bIsRoshanAlive;
	bool m_bSpawnRequested;
	CHandle< CBaseEntity > m_hRoshan;
	GameTime_t m_fRoshanKillTime;
	int32 m_nSentRoshReclaim;
	int32 m_nSentRoshRespawn;
	float32 m_fRoshanRespawnDuration;
	int32 m_iLastKillerTeam;
	int32 m_iKillCount;
	Vector m_vRoshanAltLocation;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndex2;
};
