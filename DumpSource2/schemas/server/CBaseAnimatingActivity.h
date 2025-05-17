// MNetworkVarNames = "bool m_bShouldAnimateDuringGameplayPause"
// MNetworkVarNames = "bool m_bInitiallyPopulateInterpHistory"
class CBaseAnimatingActivity : public CBaseModelEntity
{
	// MNetworkEnable
	bool m_bShouldAnimateDuringGameplayPause;
	// MNetworkEnable
	bool m_bInitiallyPopulateInterpHistory;
	bool m_bAnimationUpdateScheduled;
	CUtlVector< CUtlString >* m_pSuppressedAnimEventTags;
};
