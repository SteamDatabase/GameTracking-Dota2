class CTargetWarpUpdateNode
{
	CAnimParamHandle m_hTargetPositionParameter;
	CAnimParamHandle m_hTargetUpVectorParameter;
	CAnimParamHandle m_hTargetFacePositionParameter;
	bool m_bTargetFacePositionIsWorldSpace;
	bool m_bTargetPositionIsWorldSpace;
	bool m_bOnlyWarpWhenTagIsFound;
	bool m_bWarpOrientationDuringTranslation;
	float32 m_flMaxAngle;
};
