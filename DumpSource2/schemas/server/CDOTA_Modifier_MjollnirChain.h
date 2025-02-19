class CDOTA_Modifier_MjollnirChain
{
	int32 chain_radius;
	int32 chain_strikes;
	int32 chain_damage;
	float32 chain_delay;
	int32 chain_damage_per_charge;
	int32 m_iCurJumpCount;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};
