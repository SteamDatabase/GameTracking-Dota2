class CDestructiblePartsSystemData
{
	CUtlOrderedMap< HitGroup_t, CDestructiblePartsSystemData_HitGroupInfoAndPartData > m_PartsDataByHitGroup;
	CRangeInt m_nMinMaxNumberHitGroupsToDestroyWhenGibbing;
};
