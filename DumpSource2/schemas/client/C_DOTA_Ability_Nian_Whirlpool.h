class C_DOTA_Ability_Nian_Whirlpool : public C_DOTABaseAbility
{
	int32 pool_count;
	int32 min_distance;
	int32 max_distance;
	int32 pull_radius;
	float32 fire_interval;
	CountdownTimer m_ctTimer;
	float32 m_flTiming;
};
