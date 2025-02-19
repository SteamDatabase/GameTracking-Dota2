class C_DOTA_Unit_Roshan
{
	int32 m_iKillerTeam;
	int32 m_iLastHealthPercent;
	ParticleIndex_t m_nFXIndex;
	CHandle< C_BaseEntity > m_hRadiantRoshanPit;
	CHandle< C_BaseEntity > m_hDireRoshanPit;
	CHandle< C_BaseEntity > m_hRiverMidpoint;
	CUtlVector< CHandle< C_BaseEntity > > m_hAttackingHeroes;
	bool m_bGoldenRoshan;
};
