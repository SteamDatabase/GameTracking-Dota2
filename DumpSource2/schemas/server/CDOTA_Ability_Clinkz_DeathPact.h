class CDOTA_Ability_Clinkz_DeathPact : public CDOTABaseAbility
{
	int32 m_nDevourFirstSlot;
	bool m_bGoToTargetPosition;
	CUtlVector< CHandle< CBaseEntity > > m_hSkeletonSummons;
};
