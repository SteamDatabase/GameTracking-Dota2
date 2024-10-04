class CDOTA_Modifier_AghsFort_Creature_Phoenix_Sun : public CDOTA_Buff
{
	float32 aura_radius;
	float32 stun_duration;
	int32 max_hero_attacks;
	int32 max_hero_attacks_scepter;
	int32 max_hero_attacks_required;
	float32 caster_life_pct;
	CHandle< C_BaseEntity > m_hSecondaryTarget;
	int32 m_iAttackCount;
}
