class CDOTA_Modifier_Rubick_FadeBolt : public CDOTA_Buff
{
	float32 radius;
	int32 damage;
	int32 jump_damage_reduction_pct;
	float32 jump_delay;
	int32 m_iCurJumpCount;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
}
