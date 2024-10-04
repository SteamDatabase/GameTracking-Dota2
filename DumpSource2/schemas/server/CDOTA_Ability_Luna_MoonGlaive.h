class CDOTA_Ability_Luna_MoonGlaive : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_vecMarkedUnits;
	int32 m_iAttackIndex;
	CUtlVector< sGlaiveInfo > m_GlaiveInfo;
}
