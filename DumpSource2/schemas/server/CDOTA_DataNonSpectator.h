class CDOTA_DataNonSpectator
{
	CUtlVectorEmbeddedNetworkVar< DataTeamPlayer_t > m_vecDataTeam;
	uint64[256] m_bWorldTreeState;
	CUtlVectorEmbeddedNetworkVar< TreeModelReplacement_t > m_vecWorldTreeModelReplacements;
	Vector2D[2] m_vDesiredWardPlacement;
	int32[5] m_nEnemyStartingPosition;
	HeroID_t m_nCaptainInspectedHeroID;
	float32[20] m_flSuggestedWardWeights;
	uint8[20] m_nSuggestedWardIndexes;
	int32[5] m_iSuggestedLanes;
	float32[5] m_iSuggestedLaneWeights;
	bool[5] m_bSuggestedLaneRoam;
	bool[5] m_bSuggestedLaneJungle;
	CUtlVectorEmbeddedNetworkVar< TierNeutralInfo_t > m_vecNeutralItemsTierInfo;
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_vecNeutralStashItems;
	CNetworkUtlVectorBase< AbilityID_t > m_vecNeutralItemsConsumed;
	CUtlVectorEmbeddedNetworkVar< PingConfirmationState_t > m_PingConfirmationStates;
	CNetworkUtlVectorBase< CHandle< CBaseEntity > > m_vecKnownClearCamps;
	Vector2D[100] m_vPossibleWardPlacement;
	float32[100] m_vPossibleWardRadii;
	CUtlVectorEmbeddedNetworkVar< DOTATeleportInfo_t > m_vecTrackedTeleports;
	CRoshanPhaseInfo m_roshanSpawnInfo;
	int32 m_iTowerKills;
};
