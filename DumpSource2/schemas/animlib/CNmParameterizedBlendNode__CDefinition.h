class CNmParameterizedBlendNode::CDefinition
{
	CUtlVectorFixedGrowable< int16, 5 > m_sourceNodeIndices;
	int16 m_nInputParameterValueNodeIdx;
	bool m_bAllowLooping;
};
