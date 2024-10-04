class CDOTA_Modifier_Item_Bloodthorn : public CDOTA_Buff_Item
{
	CUtlVector< int16 > m_InFlightAttackRecords;
	int32 bonus_intellect;
	float32 bonus_mana_regen;
	int32 bonus_damage;
	int32 bonus_attack_speed;
	int32 spell_amp;
	int32 mana_regen_multiplier;
	int32 bonus_magic_resist;
	float32 duration;
	int32 passive_proc_damage;
	int32 proc_chance;
	float32 bonus_health_regen;
};
