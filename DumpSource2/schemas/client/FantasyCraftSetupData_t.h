class FantasyCraftSetupData_t
{
	FantasyCraftDataID_t m_unID;
	CUtlVector< FantasyCraftingTitleData_t > m_vecPrefixes;
	CUtlVector< FantasyCraftingTitleData_t > m_vecSuffixes;
	CUtlVector< FantasyCraftingGemData_t > m_vecGems;
	CUtlVector< FantasyCraftingShapeData_t > m_vecShapes;
	CUtlVector< FantasyCraftingQualityData_t > m_vecQualities;
	CUtlVector< FantasyCraftingTabletData_t > m_vecTablets;
	CUtlVector< FantasyCraftOperationBucket_t > m_vecOperations;
};
