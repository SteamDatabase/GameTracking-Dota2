class CDOTA_Modifier_Visage_SoulAssumption : public CDOTA_Buff
{
	int32 radius;
	int32 stack_limit;
	int32 damage_limit;
	float32 stack_duration;
	float32 damage_min;
	float32 damage_max;
	ParticleIndex_t m_nFxIndexA;
	ParticleIndex_t m_nFxIndexB;
	int32 iCur_stack;
	float32 m_fTotalDamage;
}
