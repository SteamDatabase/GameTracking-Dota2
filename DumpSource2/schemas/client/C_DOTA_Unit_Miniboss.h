// MNetworkVarNames = "int m_nVisualTeam"
class C_DOTA_Unit_Miniboss : public C_DOTA_BaseNPC_Additive
{
	// MNetworkEnable
	int32 m_nVisualTeam;
	GameTime_t m_flTransitionTimestamp;
	int32 m_nTempViewer;
	CUtlVector< CHandle< C_BaseEntity > > m_hAttackingHeroes;
	ParticleIndex_t nShieldFX;
};
