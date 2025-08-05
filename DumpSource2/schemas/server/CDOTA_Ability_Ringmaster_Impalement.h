class CDOTA_Ability_Ringmaster_Impalement : public CDOTABaseAbility
{
	Vector m_vStartPos;
	int32 dagger_width;
	CUtlVector< int32 > m_ImpactedProjectiles;
	CUtlVector< std::pair< int32, CHandle< CBaseEntity > > > m_vecBoxedUnitHits;
};
