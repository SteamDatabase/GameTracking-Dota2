class CDOTA_Ability_Centaur_Stampede : public CDOTABaseAbility
{
	float32 duration;
	int32 base_damage;
	float32 strength_damage;
	float32 slow_duration;
	float32 scepter_bonus_duration;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
	int32 m_nHeroesHit;
	bool m_bHitInvisibleHero;
};
