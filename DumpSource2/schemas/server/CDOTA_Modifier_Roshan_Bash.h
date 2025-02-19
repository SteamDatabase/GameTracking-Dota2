class CDOTA_Modifier_Roshan_Bash
{
	int32 bash_chance;
	int32 bonus_damage;
	float32 stun_duration;
	GameTime_t last_attack_time;
	CUtlVector< int16 > m_ProcAttackRecords;
	GameTime_t apply_activity_modifier_until;
};
