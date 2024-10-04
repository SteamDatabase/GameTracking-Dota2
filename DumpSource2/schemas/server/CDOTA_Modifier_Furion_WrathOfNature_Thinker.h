class CDOTA_Modifier_Furion_WrathOfNature_Thinker : public CDOTA_Buff
{
	int32 damage;
	int32 max_targets;
	int32 damage_percent_add;
	float32 jump_delay;
	int32 m_iFixedDamage;
	GameTime_t m_flLastTickTime;
	float32 m_flTimeAccumulator;
	CUtlVector< CHandle< CBaseEntity > > m_hHitTargets;
	int32 m_nBaseDamage;
	int32 m_nMaxTargets;
	float32 m_flJumpDelay;
}
