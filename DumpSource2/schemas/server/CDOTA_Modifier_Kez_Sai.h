class CDOTA_Modifier_Kez_Sai : public CDOTA_Buff
{
	int32 sai_attack_range;
	int32 sai_proc_vuln_chance;
	int32 shard_base_movement_speed;
	int32 shard_vuln_movement_speed;
	float32 vuln_duration;
	float32 sai_base_attack_time;
	int32 m_nCachedShardVulnMS;
	int32 m_nEnemiesWithVuln;
};
