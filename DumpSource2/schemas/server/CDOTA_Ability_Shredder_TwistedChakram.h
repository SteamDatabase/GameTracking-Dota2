class CDOTA_Ability_Shredder_TwistedChakram
{
	int32 radius;
	int32 speed;
	int32 damage;
	float32 debuff_duration;
	CHandle< CBaseEntity > m_hTarget;
	CUtlVector< CHandle< CBaseEntity > > m_vecHitEntities;
};
