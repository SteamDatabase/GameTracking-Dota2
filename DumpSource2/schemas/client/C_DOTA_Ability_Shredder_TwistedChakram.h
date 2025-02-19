class C_DOTA_Ability_Shredder_TwistedChakram
{
	int32 radius;
	int32 speed;
	int32 damage;
	float32 debuff_duration;
	CHandle< C_BaseEntity > m_hTarget;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHitEntities;
};
