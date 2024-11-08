class COrientationWarpUpdateNode : public CUnaryUpdateNode
{
	AnimValueSource m_eTarget;
	CAnimParamHandle m_hTargetParam;
	CAnimParamHandle m_hTargetPositionParam;
	float32 m_flTargetOffset;
	CAnimInputDamping m_damping;
	float32 m_flSmoothDampingDuration;
	bool m_bAddRootMotionIfNeeded;
	float32 m_flMaxRootMotionScale;
	bool m_bEnablePreferredRotationDirection;
	AnimValueSource m_ePreferredRotationDirection;
	float32 m_flPreferredRotationThreshold;
};
