class CDOTA_Modifier_Phoenix_Sun : public CDOTA_Buff
{
	float32 aura_radius;
	float32 stun_duration;
	int32 max_hero_attacks;
	int32 max_hero_attacks_scepter;
	int32 max_hero_attacks_required;
	CHandle< CBaseEntity > m_hSecondaryTarget;
	int32 m_iAttackCount;
	int32 creep_attacks_count;
}
