class CMatch3OpponentDefinition
{
	Match3OpponentID_t m_unOpponentID;
	CUtlString m_sLocName;
	CUtlString m_sLocFlavor;
	CUtlString m_sUnitName;
	CUtlString m_sModelName;
	HeroID_t m_nHeroID;
	CUtlVector< CMatch3OpponentHeroItemDefinition > m_vecHeroItems;
	int32 m_nHeroPrimarySlotIndex;
	int32 m_nHeroModelIndex;
	int32 m_nHeroSkinOverride;
	Vector m_vModelOffset;
	float32 m_flModelScale;
	float32 m_flMaxHealth;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAttackParticleEffect;
	CUtlString m_sAttackImpactSound;
	CUtlVector< CMatch3OpponentActionInstanceDefinition > m_vecIntroActions;
	CUtlVector< CMatch3OpponentActionInstanceDefinition > m_vecRepeatingActions;
	CUtlVector< CMatch3OpponentActionInstanceDefinition > m_vecOutroActions;
}
