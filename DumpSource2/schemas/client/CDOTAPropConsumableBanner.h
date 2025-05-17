// MNetworkVarNames = "bool m_bUseAvatar"
class CDOTAPropConsumableBanner : public C_DynamicProp
{
	PlayerID_t m_nPlayerID;
	CStrongHandle< InfoForResourceTypeCTextureBase > m_hAvatarTexture;
	// MNetworkEnable
	bool m_bUseAvatar;
};
