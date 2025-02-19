class CDOTA_Modifier_Pangolier_ShieldCrash_Buff
{
	ParticleIndex_t m_nFXIndex;
	int32 m_nAbsorbRemaining;
	int32 hero_shield;
	int32 base_shield;
	int32 accummulated_value;
	float32 parry_cooldown;
	int32 parry_chance;
	int32 parry_swashbuckles;
	int32 parry_damage_threshold;
	GameTime_t m_flLastParryTime;
};
