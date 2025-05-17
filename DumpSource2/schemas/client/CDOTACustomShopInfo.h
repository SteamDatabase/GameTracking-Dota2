// MNetworkVarNames = "char m_CustomShopName"
// MNetworkVarNames = "CDOTACustomShopItemInfo m_CustomShopItems"
class CDOTACustomShopInfo
{
	// MNetworkEnable
	char[256] m_CustomShopName;
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< CDOTACustomShopItemInfo > m_CustomShopItems;
};
