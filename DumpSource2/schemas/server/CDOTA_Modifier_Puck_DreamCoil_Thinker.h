class CDOTA_Modifier_Puck_DreamCoil_Thinker : public CDOTA_Buff
{
	CUtlVector< CHandle< CBaseEntity > > m_hLinkedEntities;
	float32 coil_radius;
	float32 coil_break_radius;
	float32 coil_initial_damage;
	float32 coil_stun_duration;
	float32 coil_duration;
	float32 coil_break_damage;
	CUtlVector< ParticleIndex_t > m_FXIndex;
};
