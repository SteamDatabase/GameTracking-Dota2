class CDOTA_Unit_Hero_MonkeyKing : public CDOTA_BaseNPC_Hero
{
	uint32 m_nTreeDisguise;
	uint32 m_nPerchedTree;
	Vector m_vLastPos;
	bool m_bIsOnCloud;
	float32 m_fTotalDistOnCloud;
	float32 m_fTotalDistoffCloud;
	float32 m_fBackOnCloudThresh;
}
