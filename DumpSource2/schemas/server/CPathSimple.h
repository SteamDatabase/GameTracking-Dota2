class CPathSimple : public CBaseEntity
{
	CUtlString m_pathString;
	CUtlVector< Vector > m_vecPathSamplePositions;
	CUtlVector< float32 > m_vecPathSampleParameters;
	CUtlVector< float32 > m_vecPathSampleDistances;
};
