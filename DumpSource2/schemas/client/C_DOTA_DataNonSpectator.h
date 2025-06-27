// MNetworkIncludeByName = "m_iTeamNum"
// MNetworkVarNames = "DataTeamPlayer_t m_vecDataTeam"
// MNetworkVarNames = "uint64 m_bWorldTreeState"
// MNetworkVarNames = "TreeModelReplacement_t m_vecWorldTreeModelReplacements"
// MNetworkVarNames = "Vector2D m_vDesiredWardPlacement"
// MNetworkVarNames = "int m_nEnemyStartingPosition"
// MNetworkVarNames = "int m_nTotalEventPoints"
// MNetworkVarNames = "HeroID_t m_nCaptainInspectedHeroID"
// MNetworkVarNames = "int m_nFeaturedPlayerID"
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
// MNetworkVarNames = "int m_nNextPowerRuneType"
// MNetworkVarNames = "int m_nNextPowerRuneSpawnIndex"
class C_DOTA_DataNonSpectator : public C_BaseEntity
{
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< DataTeamPlayer_t > m_vecDataTeam;
	// MNetworkEnable
	// MNetworkEncoder = "fixed64"
	// MNetworkChangeCallback = "OnTeamWorldTreeStateChanged"
	uint64[256] m_bWorldTreeState;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnTeamWorldTreeModelsChanged"
	C_UtlVectorEmbeddedNetworkVar< TreeModelReplacement_t > m_vecWorldTreeModelReplacements;
	// MNetworkEnable
	Vector2D[2] m_vDesiredWardPlacement;
	// MNetworkEnable
	int32[5] m_nEnemyStartingPosition;
	// MNetworkEnable
	int32 m_nTotalEventPoints;
	// MNetworkEnable
	HeroID_t m_nCaptainInspectedHeroID;
	// MNetworkEnable
	int32 m_nFeaturedPlayerID;
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
	C_UtlVectorEmbeddedNetworkVar< TierNeutralInfo_t > m_vecNeutralItemsTierInfo;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnTeamNeutralStashItemsChanged"
	C_NetworkUtlVectorBase< CHandle< C_BaseEntity > > m_vecNeutralStashItems;
	// MNetworkEnable
	C_NetworkUtlVectorBase< AbilityID_t > m_vecNeutralItemsConsumed;
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< PingConfirmationState_t > m_PingConfirmationStates;
	// MNetworkEnable
	C_NetworkUtlVectorBase< CHandle< C_BaseEntity > > m_vecKnownClearCamps;
	// MNetworkEnable
	Vector2D[100] m_vPossibleWardPlacement;
	// MNetworkEnable
	float32[100] m_vPossibleWardRadii;
	// MNetworkEnable
	C_UtlVectorEmbeddedNetworkVar< DOTATeleportInfo_t > m_vecTrackedTeleports;
	// MNetworkEnable
	CRoshanPhaseInfo m_roshanSpawnInfo;
	// MNetworkEnable
	int32 m_nNextPowerRuneType;
	// MNetworkEnable
	int32 m_nNextPowerRuneSpawnIndex;
};
