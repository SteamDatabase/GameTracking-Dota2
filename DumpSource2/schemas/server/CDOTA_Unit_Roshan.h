class CDOTA_Unit_Roshan
{
	int32 m_iKillerTeam;
	int32 m_iLastHealthPercent;
	ParticleIndex_t m_nFXIndex;
	CHandle< CBaseEntity > m_hRadiantRoshanPit;
	CHandle< CBaseEntity > m_hDireRoshanPit;
	CHandle< CBaseEntity > m_hRiverMidpoint;
	CUtlVector< CHandle< CBaseEntity > > m_hAttackingHeroes;
	bool m_bGoldenRoshan;
};
