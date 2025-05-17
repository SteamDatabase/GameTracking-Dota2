class CDOTA_Modifier_Zuus_ArcLightning : public CDOTA_Buff
{
	float32 radius;
	int32 jump_count;
	int32 arc_damage;
	float32 jump_delay;
	int32 total_damage_pct;
	int32 m_iCurJumpCount;
	bool trigger_spell_absorb;
	Vector m_vCurTargetLoc;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitEntities;
};
