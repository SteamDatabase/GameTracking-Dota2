class CDOTA_Unit_Courier : public CDOTA_BaseNPC_Additive
{
	bool m_bUnitRespawned;
	bool m_bPreUpdateFlyingCourier;
	PlayerID_t m_nSoleControllingPlayer;
	bool m_bFlyingCourier;
	GameTime_t m_flRespawnTime;
	CourierState_t m_nCourierState;
	CHandle< CBaseEntity > m_hCourierStateEntity;
	CUtlString m_strCourierModel;
	CUtlString m_strFlyingCourierModel;
	Vector m_vSpawnLocation;
}
