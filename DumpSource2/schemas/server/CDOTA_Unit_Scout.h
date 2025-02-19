class CDOTA_Unit_Scout
{
	bool m_bUnitRespawned;
	PlayerID_t m_nSoleControllingPlayer;
	GameTime_t m_flRespawnTime;
	ScoutState_t m_nScoutState;
	CHandle< CBaseEntity > m_hScoutStateEntity;
	CUtlString m_strScoutModel;
	Vector m_vSpawnLocation;
};
