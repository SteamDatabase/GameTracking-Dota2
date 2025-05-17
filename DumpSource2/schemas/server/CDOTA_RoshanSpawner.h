// MNetworkVarNames = "int m_iLastKillerTeam"
// MNetworkVarNames = "int m_iKillCount"
// MNetworkVarNames = "EHANDLE m_hRoshan"
class CDOTA_RoshanSpawner : public CPointEntity
{
	bool m_bIsRoshanAlive;
	bool m_bSpawnRequested;
	GameTime_t m_fRoshanKillTime;
	int32 m_nSentRoshReclaim;
	int32 m_nSentRoshRespawn;
	float32 m_fRoshanRespawnDuration;
	// MNetworkEnable
	int32 m_iLastKillerTeam;
	// MNetworkEnable
	int32 m_iKillCount;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hRoshan;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndex2;
};
