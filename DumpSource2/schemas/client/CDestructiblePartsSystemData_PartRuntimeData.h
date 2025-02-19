class CDestructiblePartsSystemData_PartRuntimeData
{
	CSkillInt m_nHealth;
	EDestructiblePartDamagePassThroughType m_nDamagePassthroughType;
	bool m_bKillEntityOnDestruction;
	CGlobalSymbol m_sCustomDeathHandshake;
	bool m_bShouldDestroyOnDeath;
	CRangeFloat m_flDeathDestroyTime;
};
