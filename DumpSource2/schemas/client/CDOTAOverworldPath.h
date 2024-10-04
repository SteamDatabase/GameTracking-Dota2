class CDOTAOverworldPath
{
	OverworldPathID_t m_unID;
	OverworldNodeID_t m_unNodeStart;
	OverworldNodeID_t m_unNodeEnd;
	uint8 m_unCost;
	float32 m_flCircleInvRadius;
	CUtlVector< CUtlString > m_vecRequiredTokenNames;
};
