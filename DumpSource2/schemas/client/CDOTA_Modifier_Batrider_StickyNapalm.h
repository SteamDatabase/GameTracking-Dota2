class CDOTA_Modifier_Batrider_StickyNapalm : public CDOTA_Buff
{
	float32 movement_speed_pct;
	int32 turn_rate_pct;
	float32 damage;
	float32 application_damage;
	float32 building_damage_pct;
	float32 creep_damage_pct;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXStackIndex;
};
