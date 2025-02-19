class C_DOTA_Unit_Scout
{
	bool m_bUnitRespawned;
	PlayerID_t m_nSoleControllingPlayer;
	GameTime_t m_flRespawnTime;
	ScoutState_t m_nScoutState;
	CHandle< C_BaseEntity > m_hScoutStateEntity;
};
