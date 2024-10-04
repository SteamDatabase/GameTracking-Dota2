class CDOTA_TempTree : public CBaseAnimatingActivity
{
	GameTime_t m_fExpireTime;
	Vector m_vecTreeCircleCenter;
	bool m_bCanApplyTreeCostume;
	bool m_bIsMangoTree;
	CUtlVector< ParticleIndex_t > m_ParticleList;
	bool m_bIsPartOfFowSystem;
	bool[15] m_bForceVisible;
};
