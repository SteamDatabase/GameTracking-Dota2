class CNmStateMachineNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< CNmStateMachineNode::StateDefinition_t, 5 > m_stateDefinitions;
	int16 m_nDefaultStateIndex;
};
