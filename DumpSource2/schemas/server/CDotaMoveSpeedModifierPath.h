class CDotaMoveSpeedModifierPath : public CBaseEntity
{
	float32 m_flPathLength;
	CUtlVector< DotaModifierPathNode_t > m_vecNodes;
	CHandle< CBaseEntity > m_hTrigger;
};
