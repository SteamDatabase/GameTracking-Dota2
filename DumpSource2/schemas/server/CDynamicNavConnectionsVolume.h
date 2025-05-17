class CDynamicNavConnectionsVolume : public CTriggerMultiple
{
	CUtlSymbolLarge m_iszConnectionTarget;
	CUtlVector< DynamicVolumeDef_t > m_vecConnections;
	bool m_bConnectionsEnabled;
	float32 m_flTargetAreaSearchRadius;
	float32 m_flMinDetachDistance;
};
