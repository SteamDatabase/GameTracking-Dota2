class CDOTA_Modifier_FacelessVoid_TimeLock : public CDOTA_Buff
{
	float32 duration;
	float32 duration_creep;
	float32 delay;
	int32 chance_pct;
	int32 bonus_damage;
	GameTime_t last_attack_time;
	CUtlVector< int16 > m_ProcAttackRecords;
	GameTime_t apply_activity_modifier_until;
	GameTime_t disable_activity_modifier_until;
	CUtlOrderedMap< CHandle< C_DOTA_BaseNPC >, int32 > m_mapTargets;
}
