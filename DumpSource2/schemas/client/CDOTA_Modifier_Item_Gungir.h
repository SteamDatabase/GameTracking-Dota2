class CDOTA_Modifier_Item_Gungir : public CDOTA_Buff_Item
{
	int32 bonus_damage;
	int32 bonus_attack_speed;
	int32 bonus_strength;
	int32 bonus_agility;
	int32 bonus_intellect;
	int32 bonus_hp;
	int32 chain_chance;
	int32 chain_strikes;
	int32 chain_damage;
	int32 chain_radius;
	float32 chain_cooldown;
	CUtlVector< int16 > m_InFlightAttackRecords;
	CountdownTimer m_ChainTimer;
};
