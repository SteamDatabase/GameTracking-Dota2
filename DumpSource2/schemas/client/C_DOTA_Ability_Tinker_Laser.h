class C_DOTA_Ability_Tinker_Laser : public C_DOTABaseAbility
{
	Vector m_vProjectileLocation;
	bool bBlocked;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
};
