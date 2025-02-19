class CDOTA_Ability_Windrunner_Powershot
{
	GameTime_t m_fStartTime;
	float32 m_fPower;
	int32 m_iProjectile;
	float32 damage_reduction;
	float32 arrow_width;
	int32 powershot_damage;
	float32 tree_width;
	float32 slow;
	float32 slow_duration;
	float32 min_execute_threshold;
	float32 max_execute_threshold;
	bool m_bAwardedKillEater;
	int32 m_nHeroesHit;
	ParticleIndex_t m_nFXIndex;
};
