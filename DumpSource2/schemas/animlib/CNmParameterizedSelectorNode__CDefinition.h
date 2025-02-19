class CNmParameterizedSelectorNode::CDefinition
{
	CUtlLeanVectorFixedGrowable< int16, 5 > m_optionNodeIndices;
	CUtlLeanVectorFixedGrowable< uint8, 5 > m_optionWeights;
	int16 m_parameterNodeIdx;
};
