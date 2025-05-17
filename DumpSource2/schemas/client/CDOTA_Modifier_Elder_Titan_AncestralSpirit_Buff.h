class CDOTA_Modifier_Elder_Titan_AncestralSpirit_Buff : public CDOTA_Buff
{
	float32 move_pct_creeps;
	float32 move_pct_heroes;
	int32 damage_creeps;
	int32 damage_heroes;
	float32 armor_creeps;
	float32 armor_heroes;
	float32 move_pct_cap;
	int32 m_nCreepsHit;
	int32 m_nHeroesHit;
	float32 m_fSpeedPercentage;
	int32 m_nDamage;
	int32 m_nArmor;
	bool m_bSpellImmunity;
};
