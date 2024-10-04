class CDOTAOverworldHero
{
	OverworldHeroID_t m_unID;
	OverworldNodeID_t m_unStartNodeID;
	CUtlVector< OverworldNodeID_t > m_vecBlockedNodes;
	CDOTAOverworldCharacterBase m_baseAppearance;
	CUtlVector< CUtlPair< CDOTAOverworldCharacterConditional, CDOTAOverworldCharacterBase > > m_vecOverrides;
};
