class C_ColorCorrectionVolume
{
	float32 m_LastEnterWeight;
	GameTime_t m_LastEnterTime;
	float32 m_LastExitWeight;
	GameTime_t m_LastExitTime;
	bool m_bEnabled;
	float32 m_MaxWeight;
	float32 m_FadeDuration;
	float32 m_Weight;
	char[512] m_lookupFilename;
};
