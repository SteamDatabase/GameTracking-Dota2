class CDestructiblePartsSystemData_HitGroupInfoAndPartData
{
	CUtlVector< CDestructiblePartsSystemData_PartData > m_PartsData;
	HitGroup_t m_nHitGroup;
	bool m_bDisableHitGroupWhenDestroyed;
};
