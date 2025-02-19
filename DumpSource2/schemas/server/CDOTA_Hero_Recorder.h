class CDOTA_Hero_Recorder
{
	bool m_bStartRecording;
	CHandle< CDOTA_BaseNPC > m_hHero;
	CHandle< CDOTAPlayerController > m_hPlayer;
	GameTime_t m_flStartRecordingTime;
};
