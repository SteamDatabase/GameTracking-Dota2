class CDOTA_Unit_Scout : public CDOTA_BaseNPC_Additive
{
	bool m_bUnitRespawned;
	PlayerID_t m_nSoleControllingPlayer;
	GameTime_t m_flRespawnTime;
	ScoutState_t m_nScoutState;
	CHandle< CBaseEntity > m_hScoutStateEntity;
	CUtlString m_strScoutModel;
	Vector m_vSpawnLocation;
}
