class CDOTA_Modifier_Dawnbreaker_Luminosity_Attack_Buff
{
	bool m_bIsBuffedAttack;
	int32 heal_pct;
	int32 bonus_damage;
	int32 heal_radius;
	int32 heal_from_creeps;
	int32 allied_healing_pct;
	bool triggered_by_celestial_hammer;
	CUtlVector< CHandle< C_BaseEntity > > hTargets;
	float32 m_flTotalToHeal;
	bool m_bHasProccedCooldownReduction;
	float32 cooldown_reduction;
	float32 movespeed_bonus_duration;
	float32 movespeed_bonus_from_creeps;
};
