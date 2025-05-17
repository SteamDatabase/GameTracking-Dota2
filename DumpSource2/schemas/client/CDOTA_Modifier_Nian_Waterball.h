class CDOTA_Modifier_Nian_Waterball : public CDOTA_Buff
{
	int32 trail_damage_per_second;
	int32 trail_damage_radius;
	CUtlVector< int32 > m_vFXIndices;
	CUtlVector< Vector > m_vLocations;
};
