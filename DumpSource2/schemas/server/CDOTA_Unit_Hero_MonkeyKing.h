// MNetworkVarNames = "DotaTreeId_t m_nTreeDisguise"
// MNetworkVarNames = "DotaTreeId_t m_nPerchedTree"
class CDOTA_Unit_Hero_MonkeyKing : public CDOTA_BaseNPC_Hero
{
	// MNetworkEnable
	uint32 m_nTreeDisguise;
	// MNetworkEnable
	uint32 m_nPerchedTree;
	Vector m_vLastPos;
	bool m_bIsOnCloud;
	float32 m_fTotalDistOnCloud;
	float32 m_fTotalDistoffCloud;
	float32 m_fBackOnCloudThresh;
};
