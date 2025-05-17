class CDOTA_Modifier_Leshrac_Lightning_Storm : public CDOTA_Buff
{
	int32 damage;
	float32 radius;
	int32 jump_count;
	float32 slow_duration;
	float32 jump_delay;
	CHandle< CBaseEntity > hInitialTarget;
	float32 m_flDamage;
	int32 m_iCurJumpCount;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
	bool m_bGrantedGem;
	bool m_bBounceTwice;
	CHandle< CBaseEntity > m_eLastTarget;
};
