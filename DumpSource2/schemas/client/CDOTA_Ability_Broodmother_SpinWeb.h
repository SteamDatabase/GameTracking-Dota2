class CDOTA_Ability_Broodmother_SpinWeb : public C_DOTABaseAbility
{
	CUtlVector< CHandle< C_BaseEntity > > m_hWebs;
	CUtlVector< CUtlVector< CHandle< C_BaseEntity > > > m_hWebClusters;
}
