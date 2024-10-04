class CBaseAnimatingActivity : public C_BaseModelEntity
{
	bool m_bShouldAnimateDuringGameplayPause;
	bool m_bInitiallyPopulateInterpHistory;
	bool m_bAnimationUpdateScheduled;
	CUtlVector< CUtlString >* m_pSuppressedAnimEventTags;
	bool m_bHasAnimatedMaterialAttributes;
	bool m_bSuppressAnimEventSounds;
};
