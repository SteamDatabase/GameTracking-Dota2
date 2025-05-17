// MNetworkVarNames = "int m_iBrawlActive"
class C_DOTA_Ability_Brewmaster_DrunkenBrawler : public C_DOTABaseAbility
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnBrawlActiveChanged"
	int32 m_iBrawlActive;
	bool m_bUpdateIcons;
	ParticleIndex_t m_nDrunkenBrawlerFX;
};
