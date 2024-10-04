class C_DOTA_Item_Physical : public CBaseAnimatingActivity
{
	CHandle< C_DOTA_Item > m_hItem;
	bool m_bIsLowPriorityHoverItem;
	CHandle< C_DOTA_Item > m_hOldItem;
	char* m_pszParticleName;
	ParticleIndex_t m_nFXIndex;
	bool m_bShowingTooltip;
	bool m_bShowingSimpleTooltip;
}
