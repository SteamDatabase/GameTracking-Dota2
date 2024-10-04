class C_DOTA_Unit_Scout : public C_DOTA_BaseNPC_Additive
{
	bool m_bUnitRespawned;
	PlayerID_t m_nSoleControllingPlayer;
	GameTime_t m_flRespawnTime;
	ScoutState_t m_nScoutState;
	CHandle< C_BaseEntity > m_hScoutStateEntity;
}
