class CDOTA_Modifier_Batrider_StickyNapalm : public CDOTA_Modifier_Stacking_Base
{
	float32 movement_speed_pct;
	int32 turn_rate_pct;
	int32 damage;
	int32 application_damage;
	int32 building_damage_pct;
	int32 creep_damage_pct;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXStackIndex;
};
