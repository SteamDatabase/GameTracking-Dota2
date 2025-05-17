class CDOTA_Ability_Broodmother_SpinWeb : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_hWebs;
	CUtlVector< CUtlVector< CHandle< CBaseEntity > > > m_hWebClusters;
};
