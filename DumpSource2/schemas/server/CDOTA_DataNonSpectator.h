// MNetworkIncludeByName = "m_iTeamNum"
// MNetworkVarNames = "DataTeamPlayer_t m_vecDataTeam"
// MNetworkVarNames = "uint64 m_bWorldTreeState"
// MNetworkVarNames = "TreeModelReplacement_t m_vecWorldTreeModelReplacements"
// MNetworkVarNames = "Vector2D m_vDesiredWardPlacement"
// MNetworkVarNames = "int m_nEnemyStartingPosition"
// MNetworkVarNames = "HeroID_t m_nCaptainInspectedHeroID"
// MNetworkVarNames = "float m_flSuggestedWardWeights"
// MNetworkVarNames = "uint8 m_nSuggestedWardIndexes"
// MNetworkVarNames = "int m_iSuggestedLanes"
// MNetworkVarNames = "float m_iSuggestedLaneWeights"
// MNetworkVarNames = "bool m_bSuggestedLaneRoam"
// MNetworkVarNames = "bool m_bSuggestedLaneJungle"
// MNetworkVarNames = "TierNeutralInfo_t m_vecNeutralItemsTierInfo"
// MNetworkVarNames = "EHANDLE m_vecNeutralStashItems"
// MNetworkVarNames = "AbilityID_t m_vecNeutralItemsConsumed"
// MNetworkVarNames = "PingConfirmationState_t m_PingConfirmationStates"
// MNetworkVarNames = "EHANDLE m_vecKnownClearCamps"
// MNetworkVarNames = "Vector2D m_vPossibleWardPlacement"
// MNetworkVarNames = "float m_vPossibleWardRadii"
// MNetworkVarNames = "DOTATeleportInfo_t m_vecTrackedTeleports"
// MNetworkVarNames = "CRoshanPhaseInfo m_roshanSpawnInfo"
class CDOTA_DataNonSpectator : public CBaseEntity
{
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< DataTeamPlayer_t > m_vecDataTeam;
	// MNetworkEnable
	// MNetworkEncoder = "fixed64"
	uint64[256] m_bWorldTreeState;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< TreeModelReplacement_t > m_vecWorldTreeModelReplacements;
	// MNetworkEnable
	Vector2D[2] m_vDesiredWardPlacement;
	// MNetworkEnable
	int32[5] m_nEnemyStartingPosition;
	// MNetworkEnable
	HeroID_t m_nCaptainInspectedHeroID;
	// MNetworkEnable
	float32[20] m_flSuggestedWardWeights;
	// MNetworkEnable
	uint8[20] m_nSuggestedWardIndexes;
	// MNetworkEnable
	int32[5] m_iSuggestedLanes;
	// MNetworkEnable
	float32[5] m_iSuggestedLaneWeights;
	// MNetworkEnable
	bool[5] m_bSuggestedLaneRoam;
	// MNetworkEnable
	bool[5] m_bSuggestedLaneJungle;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< TierNeutralInfo_t > m_vecNeutralItemsTierInfo;
	// MNetworkEnable
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_vecNeutralStashItems;
	// MNetworkEnable
	CNetworkUtlVectorBase< AbilityID_t > m_vecNeutralItemsConsumed;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< PingConfirmationState_t > m_PingConfirmationStates;
	// MNetworkEnable
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_vecKnownClearCamps;
	// MNetworkEnable
	Vector2D[100] m_vPossibleWardPlacement;
	// MNetworkEnable
	float32[100] m_vPossibleWardRadii;
	// MNetworkEnable
	CUtlVectorEmbeddedNetworkVar< DOTATeleportInfo_t > m_vecTrackedTeleports;
	// MNetworkEnable
	CRoshanPhaseInfo m_roshanSpawnInfo;
	int32 m_iTowerKills;
};
