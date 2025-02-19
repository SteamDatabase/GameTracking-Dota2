class C_DOTA_Unit_Courier
{
	bool m_bUnitRespawned;
	bool m_bPreUpdateFlyingCourier;
	PlayerID_t m_nSoleControllingPlayer;
	bool m_bFlyingCourier;
	GameTime_t m_flRespawnTime;
	CourierState_t m_nCourierState;
	CHandle< C_BaseEntity > m_hCourierStateEntity;
};
