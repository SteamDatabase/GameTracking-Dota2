class CDOTA_Modifier_AghsFort_Watch_Tower : public CDOTA_Buff
{
	TowerState_t m_nState;
	float32 m_flYaw;
	int32 m_nCaptureDuration;
	GameTime_t m_flEffectiveCaptureStartTime;
	int32 m_nCapturingPlayerCount;
	float32 m_flCaptureProgress;
	int32 m_iCapturingTeam;
	ParticleIndex_t m_nFxOutpostAmbient;
	GameTime_t m_flDestroyTime;
	GameTime_t m_flAutoChannelCompleteTime;
	bool m_bAscensionLevelPicker;
	int32 m_nEliteChallengeLevel;
	CUtlString m_strNextRoomName;
	CUtlString m_strNextEncounterName;
	bool m_bStartedBeamFacing;
}
