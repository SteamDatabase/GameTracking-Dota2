class CTargetWarpUpdateNode : public CUnaryUpdateNode
{
	CAnimParamHandle m_hTargetPositionParameter;
	CAnimParamHandle m_hTargetUpVectorParameter;
	CAnimParamHandle m_hTargetFacePositionParameter;
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bTargetPositionIsWorldSpace;
};
