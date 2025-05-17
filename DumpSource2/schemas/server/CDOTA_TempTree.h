// MNetworkVarNames = "Vector m_vecTreeCircleCenter"
// MNetworkVarNames = "bool m_bCanApplyTreeCostume"
// MNetworkVarNames = "bool m_bIsMangoTree"
// MNetworkVarNames = "bool m_bIsPartOfFowSystem"
class CDOTA_TempTree : public CBaseAnimatingActivity
{
	GameTime_t m_fExpireTime;
	// MNetworkEnable
	Vector m_vecTreeCircleCenter;
	// MNetworkEnable
	bool m_bCanApplyTreeCostume;
	// MNetworkEnable
	bool m_bIsMangoTree;
	CUtlVector< ParticleIndex_t > m_ParticleList;
	// MNetworkEnable
	bool m_bIsPartOfFowSystem;
	bool[15] m_bForceVisible;
};
