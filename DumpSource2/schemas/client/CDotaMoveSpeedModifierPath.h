class CDotaMoveSpeedModifierPath : public C_BaseEntity
{
	float32 m_flPathLength;
	CUtlVector< DotaModifierPathNode_t > m_vecNodes;
	CHandle< C_BaseEntity > m_hTrigger;
};
