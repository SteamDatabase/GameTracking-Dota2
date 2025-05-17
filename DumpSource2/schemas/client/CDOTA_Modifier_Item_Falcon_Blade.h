class CDOTA_Modifier_Item_Falcon_Blade : public CDOTA_Buff_Item
{
	int32 bonus_damage;
	int32 bonus_damage_per_kill;
	int32 bonus_damage_per_assist;
	int32 bonus_health;
	int32 max_damage;
	float32 bonus_mana_regen;
	int32 stack_limit;
	float32 stack_duration;
	GameTime_t m_flStackDieTime;
};
