class CDOTA_Ability_Hoodwink_HuntersBoomerang
{
	int32 radius;
	int32 speed;
	int32 damage;
	float32 mark_duration;
	CHandle< CBaseEntity > m_hTarget;
	CUtlVector< CHandle< CBaseEntity > > m_vecHitEntities;
};
