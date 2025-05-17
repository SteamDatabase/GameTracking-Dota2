// MNetworkOverride = "m_baseLayer.m_hSequence"
// MNetworkVarNames = "CNetworkedSequenceOperation m_baseLayer"
// MNetworkVarNames = "float m_flPoseParameter"
// MNetworkVarNames = "int m_nNewSequenceParity"
// MNetworkVarNames = "int m_nResetEventsParity"
// MNetworkVarNames = "AnimLoopMode_t m_nAnimLoopMode"
class C_BaseAnimatingController : public CSkeletonAnimationController
{
	// MNetworkEnable
	// MNetworkChangeCallback = "baseAnimBaseLayerChanged"
	CNetworkedSequenceOperation m_baseLayer;
	bool m_bSequenceFinished;
	float32 m_flGroundSpeed;
	float32 m_flLastEventCycle;
	GameTime_t m_flLastEventAnimTime;
	float32 m_flSoundSyncTime;
	// MNetworkEnable
	// MNetworkBitCount = 10
	// MNetworkMinValue = 0.000000
	// MNetworkMaxValue = 5.000000
	// MNetworkEncodeFlags = 8
	// MNetworkPriority = 32
	// MNetworkChangeCallback = "playbackRateChanged"
	CNetworkedQuantizedFloat m_flPlaybackRate;
	GameTime_t m_flPrevAnimTime;
	GameTime_t m_flSeqStartTime;
	// MNetworkEnable
	// MNetworkBitCount = 11
	// MNetworkMinValue = 0.000000
	// MNetworkMaxValue = 1.000000
	// MNetworkUserGroup = "m_flPoseParameter"
	// MNetworkChangeCallback = "poseParametersChanged"
	float32[24] m_flPoseParameter;
	bool m_bNetworkedAnimationInputsChanged;
	uint8 m_nPrevNewSequenceParity;
	uint8 m_nPrevResetEventsParity;
	bool m_bPlaybackRateLocked;
	// MNetworkEnable
	// MNetworkPriority = 32
	// MNetworkChangeCallback = "clientSideAnimCycleReset"
	int32 m_nNewSequenceParity;
	// MNetworkEnable
	// MNetworkPriority = 32
	int32 m_nResetEventsParity;
	// MNetworkEnable
	AnimLoopMode_t m_nAnimLoopMode;
	float32 m_flCachedSequenceCycleRate;
	float32 m_flCachedGroundSpeed;
	SequenceFinishNotifyState_t m_nNotifyState;
	bool m_bHasEverDispatchedAnimEvents;
	C_CSequenceTransitioner2 m_SequenceTransitioner;
	HSequence m_hLastAnimEventSequence;
};
