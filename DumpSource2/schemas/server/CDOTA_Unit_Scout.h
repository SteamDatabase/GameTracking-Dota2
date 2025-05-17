// MNetworkVarNames = "PlayerID_t m_nSoleControllingPlayer"
// MNetworkVarNames = "GameTime_t m_flRespawnTime"
// MNetworkVarNames = "ScoutState_t m_nScoutState"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hScoutStateEntity"
class CDOTA_Unit_Scout : public CDOTA_BaseNPC_Additive
{
	bool m_bUnitRespawned;
	// MNetworkEnable
	PlayerID_t m_nSoleControllingPlayer;
	// MNetworkEnable
	GameTime_t m_flRespawnTime;
	// MNetworkEnable
	ScoutState_t m_nScoutState;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hScoutStateEntity;
	CUtlString m_strScoutModel;
	Vector m_vSpawnLocation;
};
