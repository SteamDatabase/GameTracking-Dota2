// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CDestructiblePartsSystemData_PartData
{
	// MPropertyDescription = "Name for this destructible part."
	CUtlString m_sName;
	// MPropertyStartGroup = "+Model Setup"
	// MPropertyDescription = "Name of the breakable part to trigger breaking on when health reaches zero."
	// MPropertyAttributeEditor = "VDataModelBreakPiece( m_sModelName )"
	CGlobalSymbol m_sBreakablePieceName;
	// MPropertyStartGroup = "+Model Setup/+Body Group"
	// MPropertyDescription = "Body group to set when this part is broken."
	// MPropertyAttributeEditor = "VDataModelBodyGroup( m_sModelName )"
	CGlobalSymbol m_sBodyGroupName;
	// MPropertyDescription = "Value to set for the body group when the part is broken."
	int32 m_nBodyGroupValue;
	// MPropertyStartGroup = "+Model Setup/+Animgraph"
	// MPropertyDescription = "Animgraph parameter (boolean) to set when this part is destroyed."
	// MPropertyAttributeEditor = "VDataAnimGraphParamBool( m_sModelName )"
	CGlobalSymbol m_sAnimGraphParamName_PartDestroyed;
	// MPropertyDescription = "Animgraph parameter (float) with the normalized (0-1) health of this part."
	// MPropertyAttributeEditor = "VDataAnimGraphParamFloat( m_sModelName )"
	CGlobalSymbol m_sAnimGraphParamName_PartNormalizedHealth;
	// MPropertyStartGroup = ""
	// MPropertyDescription = "Default runtime data for this part - can be overriden in npc_units.vdata if such file exists."
	CDestructiblePartsSystemData_PartRuntimeData m_DefaultRuntimeData;
};
