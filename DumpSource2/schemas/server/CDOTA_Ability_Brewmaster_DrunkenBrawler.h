// MNetworkVarNames = "int m_iBrawlActive"
class CDOTA_Ability_Brewmaster_DrunkenBrawler : public CDOTABaseAbility
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBrawlActiveChanged"
	int32 m_iBrawlActive;
	bool m_bUpdateIcons;
	ParticleIndex_t m_nDrunkenBrawlerFX;
};
