// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CDestructiblePartsSystemData_PartRuntimeData
{
	// MPropertyStartGroup = "+Damage"
	// MPropertyDescription = "Total health of this part. When it reaches 0, the part is 'broken' using the breakable prop system."
	CSkillInt m_nHealth;
	// MPropertyDescription = "How damage to this part is handled."
	EDestructiblePartDamagePassThroughType m_nDamagePassthroughType;
	// MPropertyStartGroup = "+Death"
	// MPropertyDescription = "Should the entity die when this part is destroyed?"
	bool m_bKillEntityOnDestruction;
	// MPropertyDescription = "Custom death handshake to set when this part is destroyed."
	// MPropertySuppressExpr = "m_bKillEntityOnDestruction == false"
	CGlobalSymbol m_sCustomDeathHandshake;
	// MPropertyDescription = "Whether the part should be destroyed when the entity dies."
	bool m_bShouldDestroyOnDeath;
	// MPropertyDescription = "Time after death the part should be destroyed"
	// MPropertySuppressExpr = "m_bShouldDestroyOnDeath == false"
	CRangeFloat m_flDeathDestroyTime;
};
