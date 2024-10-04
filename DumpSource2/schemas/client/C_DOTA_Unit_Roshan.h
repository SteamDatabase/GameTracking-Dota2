class C_DOTA_Unit_Roshan : public C_DOTA_BaseNPC_Additive
{
	int32 m_iKillerTeam;
	int32 m_iLastHealthPercent;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > m_hAttackingHeroes;
	bool m_bGoldenRoshan;
	bool m_bIsNightTimeMode;
};
