class CDOTA_Modifier_Passive_Lotus_Pool
{
	float32 first_lotus_pickup_time;
	float32 pickup_time_reduction_pct;
	float32 min_lotus_pickup_time;
	float32 think_interval;
	float32 radius;
	float32 m_flRemainingPickupTime;
	float32 m_flCurrentMaxPickupTime;
	int32 m_nLotusSeconds;
	CountdownTimer m_LotusTimer;
	int32 m_nRespawnSeconds;
	CountdownTimer m_RespawnTimer;
	int32 m_nLotusesAvailable;
	CountdownTimer m_LotusUpgradeTimer;
	int32 m_nLotusIndex;
	ParticleIndex_t m_nFxProgress;
	bool m_bWasInUse;
	int32 m_iAssociatedTeam;
};
