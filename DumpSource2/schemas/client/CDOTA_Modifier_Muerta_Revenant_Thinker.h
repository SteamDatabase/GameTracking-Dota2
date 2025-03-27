class CDOTA_Modifier_Muerta_Revenant_Thinker
{
	float32 m_fDeadZoneDistance;
	float32 m_fDesiredDeadZoneDistance;
	float32 damage;
	float32 hit_radius;
	float32 speed_initial;
	float32 speed_max;
	float32 acceleration;
	float32 kill_check_radius;
	float32 kill_radius_expansion;
	float32 kill_radius_expansion_speed;
	float32 hp_regen_pct;
	int32 num_revenants;
	int32 rotation_direction;
	float32 radius;
	float32 rotation_initial;
	ParticleIndex_t m_nWarningFX;
	CUtlVector< sRevenantDef > m_SpiritDefs;
};
