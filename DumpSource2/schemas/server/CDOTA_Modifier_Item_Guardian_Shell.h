class CDOTA_Modifier_Item_Guardian_Shell : public CDOTA_Buff_Item
{
	int32 all_stats;
	int32 bonus_armor;
	float32 counter_cooldown;
	GameTime_t m_flLastCounterTime;
}
