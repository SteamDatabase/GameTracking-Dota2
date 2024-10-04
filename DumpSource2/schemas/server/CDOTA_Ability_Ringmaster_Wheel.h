class CDOTA_Ability_Ringmaster_Wheel : public CDOTABaseAbility
{
	Vector m_vStartPos;
	int32 min_range;
	float32 mesmerize_radius;
	float32 knockback_radius;
	CountdownTimer m_PathTimer;
	CUtlVector< CHandle< CBaseEntity > > m_hPushedEntities;
}
