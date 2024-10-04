class CDOTA_Modifier_Visage_GravekeepersCloak : public CDOTA_Buff
{
	int32 damage_reduction;
	int32 max_layers;
	float32 minimum_damage;
	int32 recovery_time;
	float32 radius;
	int32 max_damage_reduction;
	ParticleIndex_t[4] m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	CUtlVector< CDOTA_Modifier_Visage_GravekeepersCloak_Stack* > vStacks;
}
