class CDOTA_Unit_Miniboss : public CDOTA_BaseNPC_Additive
{
	int32 m_nTimesSpawned;
	int32 m_nTempViewer;
	CUtlVector< CHandle< CBaseEntity > > m_hAttackingHeroes;
};
