// MNetworkVarNames = "PlayerID_t m_nSoleControllingPlayer"
// MNetworkVarNames = "GameTime_t m_flRespawnTime"
// MNetworkVarNames = "ScoutState_t m_nScoutState"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hScoutStateEntity"
class C_DOTA_Unit_Scout : public C_DOTA_BaseNPC_Additive
{
	bool m_bUnitRespawned;
	// MNetworkEnable
	PlayerID_t m_nSoleControllingPlayer;
	// MNetworkEnable
	GameTime_t m_flRespawnTime;
	// MNetworkEnable
	ScoutState_t m_nScoutState;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hScoutStateEntity;
};
