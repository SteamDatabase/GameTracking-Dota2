class FantasyCraftOperation_t
{
	FantasyOperationID_t m_unOperationID;
	int32 m_nRollWeight;
	EFantasyOperationTarget m_eTarget;
	CUtlString m_sLocDescription;
	CUtlVector< FantasyCraftingGemMutation_t > m_vecOperations;
}
