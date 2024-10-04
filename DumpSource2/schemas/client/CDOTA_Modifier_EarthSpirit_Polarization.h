class CDOTA_Modifier_EarthSpirit_Polarization : public CDOTA_Buff
{
	float32 damage_per_second;
	float32 damage_interval;
	float32 damage_duration;
	int32 rock_search_radius;
	CHandle< C_BaseEntity > m_hMagnetizeAbility;
}
