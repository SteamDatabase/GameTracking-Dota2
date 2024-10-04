class CDOTA_Modifier_Shredder_Reactive_Armor : public CDOTA_Buff
{
	int32 stack_limit;
	float32 stack_duration;
	int32 stacks_per_hero_attack;
	GameTime_t m_flStackDieTime;
	ParticleIndex_t[4] m_pFXIndex;
}
