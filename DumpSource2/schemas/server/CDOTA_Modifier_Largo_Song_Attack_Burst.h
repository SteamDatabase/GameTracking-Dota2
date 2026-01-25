class CDOTA_Modifier_Largo_Song_Attack_Burst : public CDOTA_Buff
{
	float32 magic_damage_bonus;
	float32 magic_damage_bonus_per_stack;
	float32 spell_amp_bonus;
	int32 num_stacks;
	ParticleIndex_t m_nFXIndex;
};
