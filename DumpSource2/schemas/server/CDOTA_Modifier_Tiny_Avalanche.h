class CDOTA_Modifier_Tiny_Avalanche
{
	CUtlVector< CDOTA_BaseNPC* > m_pHeroesHit;
	float32 radius;
	float32 total_duration;
	float32 stun_duration;
	int32 tick_count;
	int32 toss_damage_bonus_pct;
	int32 m_damage;
	int32 m_nTicks;
};
