class CNmChainSolverTask : public CNmTask
{
	int32 m_nEffectorBoneIdx;
	CTransform m_targetTransform;
	int32 m_nNumBonesInChain;
	CNmTarget m_effectorTarget;
	bool m_bIsTargetInWorldSpace;
	bool m_bIsRunningFromDeserializedData;
	CGlobalSymbol m_debugEffectorBoneID;
	CTransform m_chainStartTransformMS;
	CTransform m_debugRequestedTargetTransformMS;
	float32 m_debugTotalChainLength;
};
