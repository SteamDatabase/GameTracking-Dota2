// MNetworkVarNames = "PlayerID_t m_nSoleControllingPlayer"
// MNetworkVarNames = "bool m_bFlyingCourier"
// MNetworkVarNames = "GameTime_t m_flRespawnTime"
// MNetworkVarNames = "CourierState_t m_nCourierState"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hCourierStateEntity"
class C_DOTA_Unit_Courier : public C_DOTA_BaseNPC_Additive
{
	bool m_bUnitRespawned;
	bool m_bPreUpdateFlyingCourier;
	// MNetworkEnable
	PlayerID_t m_nSoleControllingPlayer;
	// MNetworkEnable
	bool m_bFlyingCourier;
	// MNetworkEnable
	GameTime_t m_flRespawnTime;
	// MNetworkEnable
	CourierState_t m_nCourierState;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hCourierStateEntity;
};
