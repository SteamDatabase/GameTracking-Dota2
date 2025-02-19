class CDOTA_Modifier_Morphling_Replicate
{
	CHandle< CBaseEntity > m_hTinyTreeWearable;
	float32 m_flBaseAttackRange;
	float32 m_flBaseMovementSpeed;
	CUtlSymbolLarge m_iszModelName;
	CUtlSymbolLarge m_iszProjectileName;
	HeroFacetKey_t m_nFacetKey;
	CUtlSymbolLarge m_iszOriginalModel;
	HeroID_t m_nCopiedHeroID;
	float32 m_fOriginalModelScale;
	CUtlVector< CEconItemView* > m_vecOriginalItems;
	float32 m_flOriginalStr;
	float32 m_flOriginalAgi;
	float32 m_flOriginalInt;
	int32 m_iOriginalAttackCapability;
	float32 m_flOriginalHealthPercentage;
	float32 m_flOriginalManaPercentage;
};
