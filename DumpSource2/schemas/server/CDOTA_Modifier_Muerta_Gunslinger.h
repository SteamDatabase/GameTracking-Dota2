class CDOTA_Modifier_Muerta_Gunslinger : public CDOTA_Buff
{
	float32 double_shot_chance;
	float32 target_search_bonus_range;
	int32 bonus_damage;
	CHandle< CBaseEntity > m_hSecondaryTarget;
}
