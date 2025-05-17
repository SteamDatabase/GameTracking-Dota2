class C_DOTA_BaseNPC_NeutralItemStash : public C_DOTA_BaseNPC_Building
{
	CUtlVector< ParticleIndex_t > m_vecNewItemFX;
	bool m_bHasFoundProps;
	bool m_bDidHaveNewItems;
	CUtlVector< CHandle< C_DynamicPropClientside > > m_vecProps;
};
