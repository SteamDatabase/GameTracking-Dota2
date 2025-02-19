class CBaseAnimGraph
{
	bool m_bInitiallyPopulateInterpHistory;
	IChoreoServices* m_pChoreoServices;
	bool m_bAnimGraphUpdateEnabled;
	float32 m_flMaxSlopeDistance;
	Vector m_vLastSlopeCheckPos;
	bool m_bAnimationUpdateScheduled;
	Vector m_vecForce;
	int32 m_nForceBone;
	PhysicsRagdollPose_t m_RagdollPose;
	bool m_bRagdollEnabled;
	bool m_bRagdollClientSide;
	CNetworkUtlVectorBase< uint8 > m_animGraph2SerializeData;
	int32 m_nAnimGraph2SerializeDataSizeBytes;
	int32 m_animGraph2ReloadCountSV;
};
