class CDOTAFishingGameDefinition
{
	CUtlString m_strID;
	bool m_bBurrowedFish;
	CUtlString m_strMapName;
	CUtlString m_strBurrowedFishParticle;
	CUtlVector< CDOTAFishingGameFish* > m_vecFishTypes;
	CUtlOrderedMap< CUtlString, int32 > m_mapFishNameToVecIndex;
	CUtlOrderedMap< EFishingGameFishCategory, float32 > m_mapCategoryToDifficulty;
};
