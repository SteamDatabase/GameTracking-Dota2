class CDOTA_Modifier_Item_Maelstrom
{
	int32 bonus_damage;
	int32 bonus_attack_speed;
	int32 chain_chance;
	int32 chain_strikes;
	int32 chain_damage;
	int32 chain_radius;
	float32 chain_cooldown;
	CUtlVector< int16 > m_InFlightAttackRecords;
	CountdownTimer m_ChainTimer;
};
