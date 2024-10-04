class CDOTA_Unit_Nian_Attachment : public CDOTA_BaseNPC_Additive
{
	bool m_bAttachmentBroken;
	ParticleIndex_t m_nfxIndex_tailgrow;
	CUtlVector< NianDamageTaken_t > m_vecRecentDamage;
}
