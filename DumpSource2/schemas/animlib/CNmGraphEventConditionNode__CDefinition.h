class CNmGraphEventConditionNode::CDefinition
{
	int16 m_nSourceStateNodeIdx;
	CNmBitFlags m_eventConditionRules;
	CUtlVectorFixedGrowable< CNmGraphEventConditionNode::Condition_t, 5 > m_conditions;
};
