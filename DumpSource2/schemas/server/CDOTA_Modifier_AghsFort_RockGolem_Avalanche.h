class CDOTA_Modifier_AghsFort_RockGolem_Avalanche : public CDOTA_Buff
{
	CUtlVector< CDOTA_BaseNPC* > m_pHeroesHit;
	int32 radius;
	float32 total_duration;
	float32 stun_duration;
	int32 tick_count;
	int32 m_damage;
	int32 m_nTicks;
};
