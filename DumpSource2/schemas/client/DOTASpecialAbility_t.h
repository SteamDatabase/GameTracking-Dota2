class DOTASpecialAbility_t
{
	char* m_pszName;
	char* m_pszValue;
	char* m_pszLevelKey;
	int32 m_nCount;
	float32[11] m_Values;
	uint8 m_eDisplayType;
	int32 m_nBonusesCount;
	DOTASpecialAbilityBonus_t[1] m_Bonuses;
	DOTASpecialAbilityBonus_t m_PerLevelUpBonus;
	DOTALevelingAbilityBonus_t m_ScepterBonus;
	DOTALevelingAbilityBonus_t m_ShardBonus;
	DOTAFacetAbilityBonus_t m_FacetBonus;
	CUtlStringToken m_strRequiredFacet;
	DAMAGE_TYPES m_nDamageTypeField;
	uint8 m_unLevelUpInterval;
	bool m_bSpellDamageField;
	bool m_bRequiresScepterField;
	bool m_bRequiresShardField;
	bool m_bAffectedByAoEIncrease;
	bool m_bDynamicValue;
	bool m_bAffectedByCurio;
};
