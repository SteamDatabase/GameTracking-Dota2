class CDOTA_Modifier_Puck_DreamCoil_Thinker : public CDOTA_Buff
{
	CUtlVector< CHandle< C_BaseEntity > > m_hLinkedEntities;
	int32 coil_radius;
	int32 coil_break_radius;
	int32 coil_initial_damage;
	float32 coil_stun_duration;
	float32 coil_duration;
	int32 coil_break_damage;
	CUtlVector< ParticleIndex_t > m_FXIndex;
};
