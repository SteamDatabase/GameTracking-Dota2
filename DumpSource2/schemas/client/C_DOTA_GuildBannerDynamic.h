class C_DOTA_GuildBannerDynamic
{
	bool m_bRespawnClientEntity;
	bool m_bPlaySpawnAnimation;
	uint8 m_unGuildTier;
	uint8 m_unPrimaryColor;
	uint8 m_unSecondaryColor;
	uint8 m_unPattern;
	uint64 m_unLogo;
	GuildID_t m_unGuildID;
	uint32 m_unGuildFlags;
	bool m_bUsePanelCache;
	CHandle< C_BaseEntity > m_hClientEntity;
};
