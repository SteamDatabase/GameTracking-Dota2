class CDOTA_Ability_Muerta_DeadShot : public CDOTABaseAbility
{
	float32 radius;
	float32 speed;
	Vector m_vTargetPos;
	Vector m_vEndpoint;
	CHandle< CBaseEntity > m_hTreeTarget;
	Vector m_vRicochetDir;
	CUtlVector< CHandle< CBaseEntity > > m_vEnemyHeroVisibilityOnCast;
};
