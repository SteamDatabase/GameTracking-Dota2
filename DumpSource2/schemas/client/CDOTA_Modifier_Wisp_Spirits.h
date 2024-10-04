class CDOTA_Modifier_Wisp_Spirits : public CDOTA_Buff
{
	int32 creep_damage;
	int32 hero_damage;
	int32 hit_radius;
	int32 hero_hit_radius;
	int32 explode_radius;
	int32 min_range;
	int32 max_range;
	int32 default_radius;
	int32 spirit_amount;
	float32 m_flRotation;
	float32 m_flSpiritRadius;
	int32 spirit_movement_rate;
	GameTime_t m_flNextSpawn;
	CUtlString m_strSpiritsOutSwapAbility;
}
