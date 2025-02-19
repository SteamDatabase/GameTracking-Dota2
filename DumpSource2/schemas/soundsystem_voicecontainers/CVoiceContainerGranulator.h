class CVoiceContainerGranulator
{
	float32 m_flGrainLength;
	float32 m_flGrainCrossfadeAmount;
	float32 m_flStartJitter;
	float32 m_flPlaybackJitter;
	bool m_bShouldWraparound;
	CStrongHandle< InfoForResourceTypeCVoiceContainerBase > m_sourceAudio;
};
