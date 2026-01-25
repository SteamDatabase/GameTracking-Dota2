class CDOTA_Modifier_Item_Consecrated_Wraps : public CDOTA_Buff_Item
{
	float32 bonus_spell_resist;
	float32 bonus_evasion;
	float32 stack_threshold_damage;
	float32 stack_gain_time;
	int32 max_stacks;
	float32 stack_magic_resist;
	float32 stack_evasion;
	float32 stack_heal;
	float32 heal_cd;
	GameTime_t m_flLastHealTime;
};
