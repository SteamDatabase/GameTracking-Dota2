class CDOTA_BaseNPC_AghsFort_Watch_Tower : public C_DOTA_BaseNPC_Building
{
	int32 m_nOptionNumber;
	float32 m_flMovePlayersRadius;
	CDOTA_BaseNPC_AghsFort_Watch_Tower::ExitDirection_t m_nExitDirection;
	Vector m_vExitLocation;
	int32 m_nPathSelectedID;
	int32 m_nEncounterType;
	bool m_bIsEliteEncounter;
	bool m_bIsAscensionLevelPicker;
	CUtlSymbolLarge m_strEncounterName;
	CUtlSymbolLarge m_strAscensionAbilities;
	CHandle< C_BaseEntity > m_hEffigy;
	float32 m_flYaw;
	float32 m_flStartTime;
	GameTime_t m_flCursorEnterTime;
	bool m_bShowingTooltip;
	float32 m_flLastUpdateTime;
	ParticleIndex_t m_nChannellingParticle;
	CHandle< CBaseAnimatingActivity > m_hRoomGate;
	bool m_bIsBeingChanneled;
	float32 m_flGoalCaptureProgress;
}
