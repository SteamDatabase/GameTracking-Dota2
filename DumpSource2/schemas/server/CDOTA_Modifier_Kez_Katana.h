class CDOTA_Modifier_Kez_Katana : public CDOTA_Buff
{
	int32 katana_attack_range;
	float32 katana_base_attack_time;
	int32 katana_agility_bonus_base_damage;
	int32 katana_bleed_attack_damage_pct;
	float32 katana_bleed_duration;
	int32 katana_swap_bonus_damage;
	float32 impale_duration;
	int32 bleed_as_rupture_pct;
	int32 m_nBonusPreAttackDamage;
	bool m_bBackstab;
	bool m_bShardAttack;
};
