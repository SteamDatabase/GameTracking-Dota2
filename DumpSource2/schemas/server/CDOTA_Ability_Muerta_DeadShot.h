class CDOTA_Ability_Muerta_DeadShot
{
	int32 radius;
	int32 speed;
	Vector m_vTargetPos;
	Vector m_vEndpoint;
	CHandle< CBaseEntity > m_hTreeTarget;
	Vector m_vRicochetDir;
	CUtlVector< CHandle< CBaseEntity > > m_vEnemyHeroVisibilityOnCast;
};
