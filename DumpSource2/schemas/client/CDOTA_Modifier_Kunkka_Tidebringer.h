class CDOTA_Modifier_Kunkka_Tidebringer : public CDOTA_Buff
{
	bool m_bTidebringerAttack;
	float32 cleave_starting_width;
	float32 cleave_ending_width;
	float32 cleave_distance;
	float32 damage_bonus;
	ParticleIndex_t m_nFXIndex;
	float32 cleave_damage;
	float32 cooldown_reduction_per_hero_hit;
};
