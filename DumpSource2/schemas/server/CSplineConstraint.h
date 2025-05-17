class CSplineConstraint : public CPhysConstraint
{
	Vector m_vAnchorOffsetRestore;
	bool m_bEnableLateralConstraint;
	bool m_bEnableVerticalConstraint;
	bool m_bEnableAngularConstraint;
	float32 m_flLinearFrequency;
	float32 m_flLinarDampingRatio;
};
