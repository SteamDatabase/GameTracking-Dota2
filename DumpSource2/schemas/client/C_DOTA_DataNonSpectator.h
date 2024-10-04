class C_DOTA_DataNonSpectator : public C_BaseEntity
{
	C_UtlVectorEmbeddedNetworkVar< DataTeamPlayer_t > m_vecDataTeam;
	uint64[256] m_bWorldTreeState;
	C_UtlVectorEmbeddedNetworkVar< TreeModelReplacement_t > m_vecWorldTreeModelReplacements;
	Vector2D[2] m_vDesiredWardPlacement;
	int32[5] m_nEnemyStartingPosition;
	int32 m_nTotalEventPoints;
	HeroID_t m_nCaptainInspectedHeroID;
	int32 m_nFeaturedPlayerID;
	float32[20] m_flSuggestedWardWeights;
	uint8[20] m_nSuggestedWardIndexes;
	int32[5] m_iSuggestedLanes;
	float32[5] m_iSuggestedLaneWeights;
	bool[5] m_bSuggestedLaneRoam;
	bool[5] m_bSuggestedLaneJungle;
	C_UtlVectorEmbeddedNetworkVar< TierNeutralInfo_t > m_vecNeutralItemsTierInfo;
	C_NetworkUtlVectorBase< CHandle< C_BaseEntity > > m_vecNeutralStashItems;
	C_NetworkUtlVectorBase< AbilityID_t > m_vecNeutralItemsConsumed;
	C_UtlVectorEmbeddedNetworkVar< PingConfirmationState_t > m_PingConfirmationStates;
	C_NetworkUtlVectorBase< CHandle< C_BaseEntity > > m_vecKnownClearCamps;
	Vector2D[100] m_vPossibleWardPlacement;
	float32[100] m_vPossibleWardRadii;
	C_UtlVectorEmbeddedNetworkVar< DOTATeleportInfo_t > m_vecTrackedTeleports;
};
