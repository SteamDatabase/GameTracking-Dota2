class CDOTA_Modifier_Dawnbreaker_Luminosity_Attack_Buff : public CDOTA_Buff
{
	bool m_bIsBuffedAttack;
	int32 heal_pct;
	int32 bonus_damage;
	int32 heal_radius;
	int32 heal_from_creeps;
	int32 allied_healing_pct;
	CUtlVector< CHandle< CBaseEntity > > hTargets;
	float32 m_flTotalToHeal;
	bool m_bHasProccedCooldownReduction;
	float32 cooldown_reduction;
};
