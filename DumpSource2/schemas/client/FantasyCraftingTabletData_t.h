// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPropertyAutoExpandSelf
class FantasyCraftingTabletData_t
{
	// MPropertyDescription = "Unique ID for the Tablet"
	FantasyTabletID_t m_unID;
	// MPropertyDescription = "What role is this tablet for"
	Fantasy_Roles m_eRole;
	CUtlVector< FantasyCraftingGemSlotData_t > m_vecGemSlots;
};
