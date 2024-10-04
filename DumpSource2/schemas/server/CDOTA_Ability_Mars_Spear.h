class CDOTA_Ability_Mars_Spear : public CDOTABaseAbility
{
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	int32 damage;
	CUtlVector< CHandle< CBaseEntity > > hImpaledTargetList;
	int32 m_nTargetsImpaled;
	int32 m_nMaxImpaleTargets;
	bool m_bHadBulwarkEnabled;
	Vector m_vLastTrailThinkerLocation;
	bool bHasStartedBurning;
}
