class CDOTA_Modifier_Wisp_Spirits : public CDOTA_Buff
{
	float32 creep_damage;
	float32 hero_damage;
	float32 hit_radius;
	float32 hero_hit_radius;
	float32 explode_radius;
	float32 min_range;
	float32 max_range;
	float32 default_radius;
	int32 spirit_amount;
	float32 m_flRotation;
	float32 m_flSpiritRadius;
	float32 spirit_movement_rate;
	GameTime_t m_flNextSpawn;
	CUtlString m_strSpiritsOutSwapAbility;
};
