class CDOTA_Modifier_ArcWarden_MagneticField_AttackRange : public CDOTA_Buff
{
	int32 attack_range_bonus;
	int32 attack_magic_damage;
	int32 attack_damage_bonus;
	float32 radius;
	int32 shard_magic_resist;
	int32 shard_slow_pct;
	float32 aura_origin_x;
	float32 aura_origin_y;
	CUtlVector< int16 > m_InFlightAttackRecords;
};
