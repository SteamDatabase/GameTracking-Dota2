class CDOTA_Modifier_EarthSpirit_GeomagneticGrip : public CDOTA_Buff
{
	int32 radius;
	int32 rock_damage;
	float32 pull_units_per_second;
	float32 pull_units_per_second_heroes;
	float32 total_pull_distance;
	float32 duration;
	bool m_bUsedStone;
	Vector m_vDestination;
	Vector m_vLocation;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
};
