// MNetworkVarNames = "CHandle< CDOTA_BaseNPC> m_hIllusionOwner"
// MNetworkVarNames = "bool m_bIllusionHasTree"
class CDOTA_Unit_Hero_Tiny : public CDOTA_BaseNPC_Hero
{
	CHandle< CBaseEntity > m_hTreeWearable;
	ParticleIndex_t m_nFXIndexScepterAmbient;
	// MNetworkEnable
	CHandle< CDOTA_BaseNPC > m_hIllusionOwner;
	// MNetworkEnable
	bool m_bIllusionHasTree;
};
