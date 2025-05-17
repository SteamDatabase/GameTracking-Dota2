// MNetworkVarNames = "DotaTreeId_t m_nTreeDisguise"
// MNetworkVarNames = "DotaTreeId_t m_nPerchedTree"
class C_DOTA_Unit_Hero_MonkeyKing : public C_DOTA_BaseNPC_Hero
{
	// MNetworkEnable
	uint32 m_nTreeDisguise;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnPerchedTreeChanged"
	uint32 m_nPerchedTree;
	CHandle< C_BaseEntity > m_hTreeDisguiseEnt;
};
