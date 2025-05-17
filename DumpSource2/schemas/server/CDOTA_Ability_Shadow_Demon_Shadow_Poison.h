class CDOTA_Ability_Shadow_Demon_Shadow_Poison : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > m_hPoisonedUnits;
	bool m_bHitDisruptedUnit;
	float32 radius;
	CUtlVector< CHandle< CBaseEntity > > m_hHitUnits;
};
