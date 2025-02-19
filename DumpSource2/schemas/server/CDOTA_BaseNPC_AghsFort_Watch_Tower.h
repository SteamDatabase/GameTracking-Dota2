class CDOTA_BaseNPC_AghsFort_Watch_Tower
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
	CHandle< CBaseEntity > m_hEffigy;
	int32 m_nDepth;
	CHandle< CDOTA_BaseNPC_Effigy_AghsFort > m_hPedestal;
	CHandle< CBaseEntity > m_hParticleSystem;
	CHandle< CBaseAnimatingActivity > m_hRoomGate;
	bool m_bIsBeingChanneled;
	float32 m_flGoalCaptureProgress;
};
