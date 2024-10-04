class CDOTA_Modifier_Item_Stormcrafter : public CDOTA_Buff_Item
{
	GameTime_t m_flNextHit;
	int32 passive_movement_bonus;
	float32 range;
	float32 interval;
	int32 damage;
	float32 slow_duration;
	float32 bonus_mana_regen;
	int32 max_targets;
};
