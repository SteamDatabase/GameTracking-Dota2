// MNetworkVarNames = "bool m_bStartRecording"
// MNetworkVarNames = "CHandle< CDOTA_BaseNPC> m_hHero"
// MNetworkVarNames = "CHandle< CDOTAPlayerController> m_hPlayer"
class CDOTA_Hero_Recorder : public CBaseEntity
{
	// MNetworkEnable
	bool m_bStartRecording;
	// MNetworkEnable
	CHandle< CDOTA_BaseNPC > m_hHero;
	// MNetworkEnable
	CHandle< CDOTAPlayerController > m_hPlayer;
	GameTime_t m_flStartRecordingTime;
};
