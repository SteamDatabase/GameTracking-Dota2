class C_DOTA_Ability_EmberSpirit_Activate_FireRemnant : public C_DOTABaseAbility
{
	int32 m_nProjectileID;
	Vector m_vStartLocation;
	Vector m_vProjectileLocation;
	QAngle m_ProjectileAngles;
	CHandle< C_BaseEntity > m_hRemnantToKill;
	bool m_bProjectileStarted;
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitList;
}
