class CDOTA_Modifier_Juggernaut_BladeFury : public CDOTA_Buff
{
	float32 blade_fury_radius;
	int32 blade_fury_damage_per_tick;
	float32 blade_fury_aspd_multiplier;
	float32 m_flTotalAppliedDamage;
	int32 can_crit;
	int32 bonus_movespeed;
	GameTime_t m_flNextAttack;
	bool m_bIgnoreAttackRestriction;
}
