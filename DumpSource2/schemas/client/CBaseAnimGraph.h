// MNetworkIncludeByName = "m_bClientSideRagdoll"
// MNetworkVarNames = "bool m_bInitiallyPopulateInterpHistory"
// MNetworkVarNames = "bool m_bAnimGraphUpdateEnabled"
// MNetworkVarNames = "Vector m_vecForce"
// MNetworkVarNames = "int32 m_nForceBone"
// MNetworkVarNames = "PhysicsRagdollPose_t m_RagdollPose"
// MNetworkVarNames = "bool m_bRagdollEnabled"
// MNetworkVarNames = "bool m_bRagdollClientSide"
// MNetworkVarNames = "HNmGraphDefinitionStrong m_hAnimGraph2DefinitionNetVar"
// MNetworkVarNames = "uint8 m_animGraph2FlagsNetVar"
// MNetworkVarNames = "uint8 m_animGraph2SerializeData"
// MNetworkVarNames = "int m_nAnimGraph2SerializeDataSizeBytes"
// MNetworkVarNames = "int m_animGraph2ReloadCountSV"
class CBaseAnimGraph : public C_BaseModelEntity
{
	// MNetworkEnable
	bool m_bInitiallyPopulateInterpHistory;
	bool m_bSuppressAnimEventSounds;
	// MNetworkEnable
	bool m_bAnimGraphUpdateEnabled;
	float32 m_flMaxSlopeDistance;
	Vector m_vLastSlopeCheckPos;
	bool m_bAnimationUpdateScheduled;
	// MNetworkEnable
	Vector m_vecForce;
	// MNetworkEnable
	int32 m_nForceBone;
	CBaseAnimGraph* m_pClientsideRagdoll;
	bool m_bBuiltRagdoll;
	// MNetworkEnable
	PhysicsRagdollPose_t m_RagdollPose;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientRagdollEnabledChanged"
	bool m_bRagdollEnabled;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnClientRagdollChanged"
	bool m_bRagdollClientSide;
	bool m_bHasAnimatedMaterialAttributes;
	// MNetworkEnable
	// MNetworkChangeCallback = "animGraph2DefinitionChanged"
	CStrongHandle< InfoForResourceTypeCNmGraphDefinition > m_hAnimGraph2DefinitionNetVar;
	// MNetworkEnable
	uint8 m_animGraph2FlagsNetVar;
	// MNetworkEnable
	C_NetworkUtlVectorBase< uint8 > m_animGraph2SerializeData;
	// MNetworkEnable
	int32 m_nAnimGraph2SerializeDataSizeBytes;
	// MNetworkEnable
	int32 m_animGraph2ReloadCountSV;
};
