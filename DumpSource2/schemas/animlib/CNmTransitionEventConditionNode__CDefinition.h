class CNmTransitionEventConditionNode::CDefinition
{
	CGlobalSymbol m_requireRuleID;
	CNmBitFlags m_eventConditionRules;
	int16 m_nSourceStateNodeIdx;
	NmTransitionRuleCondition_t m_ruleCondition;
};
