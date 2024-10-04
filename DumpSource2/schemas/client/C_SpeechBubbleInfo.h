class C_SpeechBubbleInfo
{
	char[256] m_LocalizationStr;
	CHandle< C_BaseEntity > m_hNPC;
	GameTime_t m_flStartTime;
	float32 m_flDuration;
	uint32 m_unOffsetX;
	uint32 m_unOffsetY;
	uint16 m_unCount;
};
