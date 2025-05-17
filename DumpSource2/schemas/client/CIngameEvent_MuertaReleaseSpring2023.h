// MNetworkVarNames = "bool m_bMiniGameActive"
// MNetworkVarNames = "int8 m_vecTargetAssignments"
// MNetworkVarNames = "uint8 m_vecMiniGamePoints"
// MNetworkVarNames = "uint8 m_vecMiniGameKills"
class CIngameEvent_MuertaReleaseSpring2023 : public C_IngameEvent_Base
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnMuertaReleaseEventMiniGameActiveChanged"
	bool m_bMiniGameActive;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnMuertaReleaseEventTargetAssignmentsChanged"
	int8[10] m_vecTargetAssignments;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnMuertaReleaseEventMiniGamePointsChanged"
	uint8[10] m_vecMiniGamePoints;
	// MNetworkEnable
	uint8[10] m_vecMiniGameKills;
	CUtlVector< ParticleIndex_t > m_activeGravestones;
};
