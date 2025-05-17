class CDOTA_Modifier_Item_Samurai_Tabi_Str : public CDOTA_Buff_Item
{
	int32 stat_per_tick;
	int32 bonus_all_stats;
	float32 base_interval;
	int32 max_tick_count;
	float32 str_root_duration;
	float32 str_root_cooldown;
	int32 str_root_chance;
	float32 str_bonus_damage;
	int32 iCurrentTickCount;
	GameTime_t m_flLastRootTime;
	CUtlVector< int16 > m_InFlightAttackRecords;
};
