class CDOTA_Ability_EmberSpirit_Activate_FireRemnant : public CDOTABaseAbility
{
	int32 m_nProjectileID;
	Vector m_vStartLocation;
	Vector m_vProjectileLocation;
	QAngle m_ProjectileAngles;
	CHandle< CBaseEntity > m_hRemnantToKill;
	bool m_bProjectileStarted;
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
};
