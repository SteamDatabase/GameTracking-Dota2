class C_DOTA_Unit_Miniboss : public C_DOTA_BaseNPC_Additive
{
	int32 m_nTimesSpawned;
	int32 m_nTempViewer;
	CUtlVector< CHandle< C_BaseEntity > > m_hAttackingHeroes;
}
