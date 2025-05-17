// MNetworkVarNames = "bool m_bStartRecording"
// MNetworkVarNames = "CHandle< C_DOTA_BaseNPC> m_hHero"
// MNetworkVarNames = "CHandle< C_DOTAPlayerController> m_hPlayer"
class C_DOTA_Hero_Recorder : public C_BaseEntity
{
	// MNetworkEnable
	bool m_bStartRecording;
	// MNetworkEnable
	CHandle< C_DOTA_BaseNPC > m_hHero;
	// MNetworkEnable
	CHandle< C_DOTAPlayerController > m_hPlayer;
	bool m_bRecording;
	bool m_bLastStartRecording;
	float32 m_flLastCycle;
	int32 m_nCompletedCycles;
	int32 m_nFramesThisCycle;
	int32 m_nRecordedFrames;
	float32 m_flHeroAdvanceTime;
	float32 m_flStartTime;
	CUtlVector< float32 > m_flCycles;
	CUtlVector< CUtlString* > m_pBatchFiles;
};
