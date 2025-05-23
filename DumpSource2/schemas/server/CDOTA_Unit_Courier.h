// MNetworkVarNames = "PlayerID_t m_nSoleControllingPlayer"
// MNetworkVarNames = "bool m_bFlyingCourier"
// MNetworkVarNames = "GameTime_t m_flRespawnTime"
// MNetworkVarNames = "CourierState_t m_nCourierState"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hCourierStateEntity"
class CDOTA_Unit_Courier : public CDOTA_BaseNPC_Additive
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
	CHandle< CBaseEntity > m_hCourierStateEntity;
	CUtlString m_strCourierModel;
	CUtlString m_strFlyingCourierModel;
	Vector m_vSpawnLocation;
	GameTime_t m_flLastLeavingFountainToastTime;
};
