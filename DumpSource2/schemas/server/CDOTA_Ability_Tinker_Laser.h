class CDOTA_Ability_Tinker_Laser : public CDOTABaseAbility
{
	Vector m_vProjectileLocation;
	bool bBlocked;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
}
