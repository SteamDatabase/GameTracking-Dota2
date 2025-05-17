class CDOTA_Modifier_Sand_King_Scorpion_Strike_Attack_Bonus : public CDOTA_Buff
{
	int32 attack_damage;
	int32 creep_damage_penalty;
	int32 inner_radius_bonus_damage_pct;
	bool m_bIsInnerRadiusHit;
	float32 damage_pct;
};
