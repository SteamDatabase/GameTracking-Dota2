class C_DOTA_Ability_Hoodwink_HuntersBoomerang : public C_DOTABaseAbility
{
	int32 radius;
	int32 speed;
	int32 damage;
	float32 mark_duration;
	CHandle< C_BaseEntity > m_hTarget;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHitEntities;
}
