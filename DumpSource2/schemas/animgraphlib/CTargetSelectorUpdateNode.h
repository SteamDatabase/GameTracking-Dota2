class CTargetSelectorUpdateNode : public CAnimUpdateNodeBase
{
	CUtlVector< CAnimUpdateNodeRef > m_children;
	CAnimParamHandle m_hTargetPosition;
	CAnimParamHandle m_hTargetFacePositionParameter;
	CAnimParamHandle m_hForwardDirectionOverrideParameter;
	bool m_bTargetPositionIsWorldSpace;
	bool m_bTargetFacePositionIsWorldSpace;
};
