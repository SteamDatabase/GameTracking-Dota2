// MEntityAllowsPortraitWorldSpawn
class C_DOTA_GuildBannerDynamic : public C_DynamicProp
{
	// MNetworkEnable
	bool m_bRespawnClientEntity;
	// MNetworkEnable
	bool m_bPlaySpawnAnimation;
	// MNetworkEnable
	uint8 m_unGuildTier;
	// MNetworkEnable
	uint8 m_unPrimaryColor;
	// MNetworkEnable
	uint8 m_unSecondaryColor;
	// MNetworkEnable
	uint8 m_unPattern;
	// MNetworkEnable
	uint64 m_unLogo;
	// MNetworkEnable
	GuildID_t m_unGuildID;
	// MNetworkEnable
	uint32 m_unGuildFlags;
	// MNetworkEnable
	bool m_bUsePanelCache;
	CHandle< C_BaseEntity > m_hClientEntity;
};
