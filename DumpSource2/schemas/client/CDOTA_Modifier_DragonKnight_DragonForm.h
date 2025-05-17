class CDOTA_Modifier_DragonKnight_DragonForm : public CDOTA_Buff
{
	int32 bonus_movement_speed;
	int32 bonus_attack_damage;
	int32 bonus_attack_range;
	int32 attack_projectile_speed_bonus;
	int32 magic_resistance;
	int32 model_scale;
	int32 iLevel;
	int32 m_iOriginalAttackCapabilities;
	CUtlSymbolLarge m_iszRangedAttackEffect;
	int32 bonus_slow_resistance;
	int32 is_green_dragon;
	int32 is_red_dragon;
	int32 is_blue_dragon;
	int32 iAssetIndex;
	float32 ranged_splash_radius;
	float32 ranged_splash_damage_pct;
};
