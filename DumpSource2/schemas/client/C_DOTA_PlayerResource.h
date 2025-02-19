class C_DOTA_PlayerResource
{
	bool m_bWasDataUpdateCreated;
	C_UtlVectorEmbeddedNetworkVar< PlayerResourcePlayerTeamData_t > m_vecPlayerTeamData;
	C_UtlVectorEmbeddedNetworkVar< PlayerResourcePlayerData_t > m_vecPlayerData;
	C_UtlVectorEmbeddedNetworkVar< PlayerResourceBroadcasterData_t > m_vecBrodcasterData;
	C_NetworkUtlVectorBase< uint32 > m_vecEventsForDisplay;
	int8 m_nPrimaryEventIndex;
	uint32 m_nObsoleteEventIDAssociatedWithEventData;
	CHandle< C_BaseEntity >[64] m_playerIDToPlayer;
	CUtlSymbolLarge[64] m_iszName;
	CUtlSymbolLarge[64] m_iszHTMLSafeName;
	CUtlSymbolLarge[64] m_iszFilteredHTMLSafeName;
	bool m_bDirtySuggestedItems;
	bool m_bDirtySelection;
	bool m_bHasWorldTreesChanged;
	bool m_bWorldTreeModelsChanged;
	bool[24] m_bSwapWillingness;
	CUtlVector< CHandle< C_DOTA_Unit_Courier > >[15] m_hTeamCouriers;
	CUtlVector< CHandle< C_DOTA_Unit_Courier > >[64] m_hPlayerCouriers;
	CUtlVector< uint32 > m_vecOnstageHomeTeams;
	PlayerSeatAssignment_t*[24] m_pPlayerIDToOnstageSlot;
	CUtlVector< PlayerSeatAssignment_t > m_vecOnstagePlayerSeats;
	int32 m_nEventNPCReplaced;
	int32 m_nEventPlayerInfo;
	int32 m_nInventoryUpdated;
};
