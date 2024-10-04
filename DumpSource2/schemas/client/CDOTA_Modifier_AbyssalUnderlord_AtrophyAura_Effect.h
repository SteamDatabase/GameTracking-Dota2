class CDOTA_Modifier_AbyssalUnderlord_AtrophyAura_Effect : public CDOTA_Buff
{
	int32 damage_reduction_pct;
	float32 bonus_damage_duration;
	float32 bonus_damage_from_creep;
	float32 bonus_damage_from_hero;
	bool m_bWasHidden;
};
