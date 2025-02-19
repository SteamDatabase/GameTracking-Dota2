class CDOTA_Unit_Miniboss
{
	int32 m_nVisualTeam;
	GameTime_t m_flTransitionTimestamp;
	int32 m_nTempViewer;
	CUtlVector< CHandle< CBaseEntity > > m_hAttackingHeroes;
	ParticleIndex_t nShieldFX;
};
