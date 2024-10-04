class CDOTA_Modifier_Watch_Tower : public CDOTA_Buff
{
	int32 m_iCapturingTeam;
	float32 m_flCaptureProgress;
	float32 m_flBonusTime;
	bool m_bInitialSetupDone;
	int32 m_iOriginalTeam;
	CHandle< C_BaseEntity > m_hPreviousHero;
	CUtlVector< PlayerID_t > m_vecLastCreditedPlayerIDs;
	float32 m_flAccumulatedCaptureTime;
	int32 m_iBonusCount;
	ParticleIndex_t m_nFxOutpostAmbient;
	ParticleIndex_t m_nFxOutpostInitialAmbient;
};
