class CDOTA_Modifier_MjollnirChain : public CDOTA_Buff
{
	int32 chain_radius;
	int32 chain_strikes;
	float32 chain_damage;
	float32 chain_delay;
	float32 chain_damage_per_charge;
	float32 illusion_multiplier_pct;
	int32 m_iCurJumpCount;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};
