class DOTASpecialAbility_t
{
	char* m_pszName;
	char* m_pszValue;
	char* m_pszLevelKey;
	char* m_pszSpecialBonusAbility;
	char* m_pszSpecialBonusField;
	char* m_pszSpecialBonusADLinkedAbilities;
	int32 m_nCount;
	float32[20] m_Values;
	int32 m_nBonusesCount;
	DOTASpecialAbilityBonus_t[4] m_Bonuses;
	DOTALevelingAbilityBonus_t m_ScepterBonus;
	DOTALevelingAbilityBonus_t m_ShardBonus;
	DOTAFacetAbilityBonus_t m_FacetBonus;
	CUtlStringToken m_strRequiredFacet;
	int32 m_nDamageTypeField;
	bool m_bSpellDamageField;
	bool m_bScepterField;
	bool m_bShardField;
	bool m_bAffectedByAoEIncrease;
	bool m_bDynamicValue;
	EDOTASpecialBonusOperation m_eSpecialBonusOperation;
}
