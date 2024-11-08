class CSurvivorsPickupDefinition
{
	SurvivorsPickupID_t m_unPickupID;
	CUtlString m_sPowerUpName;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sParticleEffect;
	int32 m_nModelIndex;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sDirectionalHelperParticle;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sOnPickupOverheadEffect;
	int32 m_nHealAmount;
	int32 m_nGoldAmount;
	bool m_bRewardsTreasure;
	int32 m_nTreasureVariant;
	bool m_bShowInMinimap;
	CUtlString m_sMinimapIconSnippet;
	bool m_bCanSpawnWithVelocity;
	float32 m_flMaxSpawnVelocity;
	CUtlString m_sDropSoundEvent;
};
