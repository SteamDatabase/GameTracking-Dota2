// MNetworkVarNames = "int m_nEncounterType"
// MNetworkVarNames = "bool m_bIsEliteEncounter"
// MNetworkVarNames = "bool m_bIsAscensionLevelPicker"
// MNetworkVarNames = "string_t m_strEncounterName"
// MNetworkVarNames = "string_t m_strAscensionAbilities"
// MNetworkVarNames = "EHANDLE m_hEffigy"
// MNetworkVarNames = "CHandle<CBaseAnimating> m_hRoomGate"
// MNetworkVarNames = "bool m_bIsBeingChanneled"
// MNetworkVarNames = "float m_flGoalCaptureProgress"
class CDOTA_BaseNPC_AghsFort_Watch_Tower : public C_DOTA_BaseNPC_Building
{
	int32 m_nOptionNumber;
	float32 m_flMovePlayersRadius;
	CDOTA_BaseNPC_AghsFort_Watch_Tower::ExitDirection_t m_nExitDirection;
	Vector m_vExitLocation;
	int32 m_nPathSelectedID;
	// MNetworkEnable
	int32 m_nEncounterType;
	// MNetworkEnable
	bool m_bIsEliteEncounter;
	// MNetworkEnable
	bool m_bIsAscensionLevelPicker;
	// MNetworkEnable
	CUtlSymbolLarge m_strEncounterName;
	// MNetworkEnable
	CUtlSymbolLarge m_strAscensionAbilities;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hEffigy;
	float32 m_flYaw;
	float32 m_flStartTime;
	GameTime_t m_flCursorEnterTime;
	bool m_bShowingTooltip;
	float32 m_flLastUpdateTime;
	ParticleIndex_t m_nChannellingParticle;
	// MNetworkEnable
	CHandle< CBaseAnimatingActivity > m_hRoomGate;
	// MNetworkEnable
	bool m_bIsBeingChanneled;
	// MNetworkEnable
	float32 m_flGoalCaptureProgress;
};
