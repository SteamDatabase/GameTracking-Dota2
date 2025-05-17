// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyAutoExpandSelf
class FantasyCraftOperation_t
{
	// MPropertyDescription = "Unique identifier for this operation"
	FantasyOperationID_t m_unOperationID;
	// MPropertyDescription = "Weight for when rolling which operations to add to the roll board"
	int32 m_nRollWeight;
	// MPropertyDescription = "What extra input is needed for the operation"
	EFantasyOperationTarget m_eTarget;
	// MPropertyDescription = "Localization String describing the operation"
	CUtlString m_sLocDescription;
	// MPropertyDescription = "What operations this will perform"
	CUtlVector< FantasyCraftingGemMutation_t > m_vecOperations;
};
