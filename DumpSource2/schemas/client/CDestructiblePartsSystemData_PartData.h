// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CDestructiblePartsSystemData_PartData
{
	// MPropertyDescription = "Name for this destructible part."
	CUtlString m_sName;
	// MPropertyStartGroup = "+Model Setup"
	// MPropertyDescription = "Name of the breakable part to trigger breaking on when health reaches zero."
	// MPropertyAttributeEditor = "ModelDocPicker( 15 )"
	CGlobalSymbol m_sBreakablePieceName;
	// MPropertyStartGroup = "+Model Setup/+Body Group"
	// MPropertyDescription = "Body group to set when this part is broken."
	// MPropertyAttributeEditor = "VDataModelBodyGroup( m_sModelName )"
	CGlobalSymbol m_sBodyGroupName;
	// MPropertyDescription = "Value to set for the body group when the part is broken."
	int32 m_nBodyGroupValue;
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
