class C_DOTA_Ability_Drow_Ranger_Glacier : public C_DOTABaseAbility
{
	int32 shard_width;
	int32 shard_count;
	float32 shard_duration;
	float32 shard_angle_step;
	int32 shard_distance;
	Vector m_vSpawnOrigin;
	Vector m_vDirection;
	CUtlVector< CHandle< C_BaseEntity > > m_vecShards;
}
