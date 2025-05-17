class CDOTA_Ability_AghsFort_Shadow_Demon_Shadow_Poison : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_hPoisonedUnits;
	int32 radius;
	CUtlVector< CHandle< CBaseEntity > > m_hHitUnits;
};
