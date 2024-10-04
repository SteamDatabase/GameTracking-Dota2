class CDOTA_Unit_Hero_Tiny : public CDOTA_BaseNPC_Hero
{
	CHandle< CBaseEntity > m_hTreeWearable;
	ParticleIndex_t m_nFXIndexScepterAmbient;
	CHandle< CDOTA_BaseNPC > m_hIllusionOwner;
	bool m_bIllusionHasTree;
};
