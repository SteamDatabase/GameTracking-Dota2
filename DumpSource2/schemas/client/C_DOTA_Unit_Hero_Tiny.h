// MNetworkVarNames = "CHandle< CDOTA_BaseNPC> m_hIllusionOwner"
// MNetworkVarNames = "bool m_bIllusionHasTree"
class C_DOTA_Unit_Hero_Tiny : public C_DOTA_BaseNPC_Hero
{
	CHandle< C_BaseEntity > m_hTreeWearable;
	ParticleIndex_t m_nFXIndexScepterAmbient;
	// MNetworkEnable
	CHandle< C_DOTA_BaseNPC > m_hIllusionOwner;
	// MNetworkEnable
	bool m_bIllusionHasTree;
};
