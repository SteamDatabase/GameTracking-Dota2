class CDOTA_Unit_Roshan : public CDOTA_BaseNPC_Additive
{
	int32 m_iKillerTeam;
	int32 m_iLastHealthPercent;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_hAttackingHeroes;
	bool m_bGoldenRoshan;
	bool m_bIsNightTimeMode;
}
