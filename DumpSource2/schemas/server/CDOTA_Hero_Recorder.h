class CDOTA_Hero_Recorder : public CBaseEntity
{
	bool m_bStartRecording;
	CHandle< CDOTA_BaseNPC > m_hHero;
	CHandle< CDOTAPlayerController > m_hPlayer;
	GameTime_t m_flStartRecordingTime;
};
