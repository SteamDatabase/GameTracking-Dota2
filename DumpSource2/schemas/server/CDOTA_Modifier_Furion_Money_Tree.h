class CDOTA_Modifier_Furion_Money_Tree : public CDOTA_Buff
{
	float32 gold_per_bag;
	float32 tick_interval;
	float32 tree_duration;
	int32 min_throw_range;
	int32 max_throw_range;
	float32 gold_bag_duration;
	int32 bags_per_tick;
	float32 hero_level_gold_multiplier;
	CHandle< CDOTA_TempTree > m_hTree;
	int32 nTargetHeroLevel;
	bool m_bInitialized;
	CHandle< CBaseEntity > m_hObstruction;
	GameTime_t m_timeLastGoldBagSpawn;
};
