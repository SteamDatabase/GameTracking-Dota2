class CUnitOrders
{
	CUtlVector< CEntityIndex > m_nUnits;
	Vector m_vPosition;
	PlayerID_t m_nIssuerPlayerIndex;
	int32 m_nOrderSequenceNumber;
	int32 m_nOrderType;
	CEntityIndex m_nTargetIndex;
	CEntityIndex m_nAbilityIndex;
	uint32 m_nFlags;
};
