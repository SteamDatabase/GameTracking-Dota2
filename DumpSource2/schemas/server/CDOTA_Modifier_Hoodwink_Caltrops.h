class CDOTA_Modifier_Hoodwink_Caltrops : public CDOTA_Buff
{
	int32 effect_radius;
	int32 caltrops_damage;
	int32 activation_radius;
	float32 debuff_duration;
	float32 activation_delay;
	ParticleIndex_t m_nFXIndex;
};
