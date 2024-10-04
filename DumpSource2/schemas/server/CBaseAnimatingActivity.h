class CBaseAnimatingActivity : public CBaseModelEntity
{
	bool m_bShouldAnimateDuringGameplayPause;
	bool m_bInitiallyPopulateInterpHistory;
	bool m_bAnimationUpdateScheduled;
	CUtlVector< CUtlString >* m_pSuppressedAnimEventTags;
};
