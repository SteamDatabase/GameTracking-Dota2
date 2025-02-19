class DOTAFacetAbilityBonus_t
{
	CUtlVector< float32 > m_vecValues;
	EDOTASpecialBonusOperation m_eOperation;
	int32 m_nSpecialBonusesCount;
	DOTASpecialAbilityBonus_t* m_pSpecialBonuses;
	DOTALevelingAbilityBonus_t* m_pScepterBonus;
	DOTALevelingAbilityBonus_t* m_pShardBonus;
};
