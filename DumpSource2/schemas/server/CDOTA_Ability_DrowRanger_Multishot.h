class CDOTA_Ability_DrowRanger_Multishot : public CDOTABaseAbility
{
	Vector m_vStartPos;
	int32 m_iArrowProjectile;
	int32 m_nFXIndex;
	float32 arrow_speed;
	int32 arrow_spread;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets0;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets1;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets2;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets3;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets4;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets5;
	CUtlVector< CHandle< CBaseEntity > > m_vHitTargets6;
}
