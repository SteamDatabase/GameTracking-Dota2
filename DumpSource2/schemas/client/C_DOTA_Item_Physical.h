// MNetworkVarNames = "CHandle< C_DOTA_Item > m_hItem"
// MNetworkVarNames = "bool m_bIsLowPriorityHoverItem"
class C_DOTA_Item_Physical : public CBaseAnimatingActivity
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnItemChanged"
	CHandle< C_DOTA_Item > m_hItem;
	// MNetworkEnable
	bool m_bIsLowPriorityHoverItem;
	CHandle< C_DOTA_Item > m_hOldItem;
	char* m_pszParticleName;
	ParticleIndex_t m_nFXIndex;
	bool m_bShowingTooltip;
	bool m_bShowingSimpleTooltip;
};
