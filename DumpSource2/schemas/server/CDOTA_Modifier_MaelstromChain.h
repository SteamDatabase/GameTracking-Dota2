class CDOTA_Modifier_MaelstromChain
{
	int32 chain_radius;
	int32 chain_strikes;
	int32 chain_damage;
	float32 chain_delay;
	int32 m_iCurJumpCount;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};
