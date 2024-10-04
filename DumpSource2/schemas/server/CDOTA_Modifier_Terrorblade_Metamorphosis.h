class CDOTA_Modifier_Terrorblade_Metamorphosis : public CDOTA_Buff
{
	float32 base_attack_time;
	int32 bonus_range;
	int32 m_iOriginalAttackCapabilities;
	int32 bonus_damage;
	int32 speed_loss;
	int32 attack_projectile_speed_bonus;
	CUtlSymbolLarge m_iszRangedAttackEffect;
	CUtlSymbolLarge m_iszOriginalRangedAttackEffect;
}
