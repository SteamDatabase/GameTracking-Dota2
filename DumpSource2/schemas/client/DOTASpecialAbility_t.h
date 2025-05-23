class DOTASpecialAbility_t
{
	char* m_pszName;
	char* m_pszValue;
	char* m_pszLevelKey;
	char* m_pszSpecialBonusAbility;
	char* m_pszSpecialBonusField;
	int32 m_nCount;
	float32[11] m_Values;
	int32 m_nBonusesCount;
	DOTASpecialAbilityBonus_t[1] m_Bonuses;
	DOTALevelingAbilityBonus_t m_ScepterBonus;
	DOTALevelingAbilityBonus_t m_ShardBonus;
	DOTAFacetAbilityBonus_t m_FacetBonus;
	CUtlStringToken m_strRequiredFacet;
	DAMAGE_TYPES m_nDamageTypeField;
	bool m_bSpellDamageField;
	bool m_bRequiresScepterField;
	bool m_bRequiresShardField;
	bool m_bAffectedByAoEIncrease;
	bool m_bDynamicValue;
	bool m_bAffectedByCurio;
	EDOTASpecialBonusOperation m_eSpecialBonusOperation;
};
