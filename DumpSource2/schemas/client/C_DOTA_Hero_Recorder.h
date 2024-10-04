class C_DOTA_Hero_Recorder : public C_BaseEntity
{
	bool m_bStartRecording;
	CHandle< C_DOTA_BaseNPC > m_hHero;
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
}
