class CDOTA_Ability_Drow_Ranger_Glacier : public CDOTABaseAbility
{
	int32 shard_width;
	int32 shard_count;
	float32 shard_duration;
	float32 shard_angle_step;
	int32 shard_distance;
	Vector m_vSpawnOrigin;
	Vector m_vDirection;
	CUtlVector< CHandle< CBaseEntity > > m_vecShards;
	CDOTABaseAbility* m_pIceShardsStop;
	ParticleIndex_t m_nFXIndex;
}
