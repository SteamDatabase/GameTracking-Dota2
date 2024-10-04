class CDOTA_Modifier_Muerta_Revenant_Thinker : public CDOTA_Buff
{
	bool m_bSpiritsExplode;
	float32 m_fDeadZoneDistance;
	float32 m_fDesiredDeadZoneDistance;
	int32 damage;
	int32 hit_radius;
	float32 speed_initial;
	float32 speed_max;
	float32 acceleration;
	int32 kill_check_radius;
	int32 kill_radius_expansion;
	float32 kill_radius_expansion_speed;
	int32 num_revenants;
	int32 rotation_direction;
	float32 radius;
	float32 rotation_initial;
	ParticleIndex_t m_nWarningFX;
	CUtlVector< sRevenantDef > m_SpiritDefs;
	int32 m_nRevenantImpacts;
};
