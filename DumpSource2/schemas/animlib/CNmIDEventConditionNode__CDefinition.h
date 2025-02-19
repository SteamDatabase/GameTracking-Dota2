class CNmIDEventConditionNode::CDefinition
{
	int16 m_nSourceStateNodeIdx;
	CNmBitFlags m_eventConditionRules;
	CUtlVectorFixedGrowable< CGlobalSymbol, 5 > m_eventIDs;
};
