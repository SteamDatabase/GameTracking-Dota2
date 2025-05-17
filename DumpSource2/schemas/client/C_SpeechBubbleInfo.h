// MNetworkVarNames = "char m_LocalizationStr"
// MNetworkVarNames = "CHandle< CBaseEntity> m_hNPC"
// MNetworkVarNames = "GameTime_t m_flStartTime"
// MNetworkVarNames = "float m_flDuration"
// MNetworkVarNames = "uint32 m_unOffsetX"
// MNetworkVarNames = "uint32 m_unOffsetY"
// MNetworkVarNames = "uint16 m_unCount"
class C_SpeechBubbleInfo
{
	// MNetworkEnable
	char[256] m_LocalizationStr;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hNPC;
	// MNetworkEnable
	GameTime_t m_flStartTime;
	// MNetworkEnable
	float32 m_flDuration;
	// MNetworkEnable
	uint32 m_unOffsetX;
	// MNetworkEnable
	uint32 m_unOffsetY;
	// MNetworkEnable
	uint16 m_unCount;
};
