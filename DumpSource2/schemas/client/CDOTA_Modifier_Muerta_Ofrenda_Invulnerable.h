class CDOTA_Modifier_Muerta_Ofrenda_Invulnerable : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexAoE;
	float32 effect_radius;
	bool bActive;
};
