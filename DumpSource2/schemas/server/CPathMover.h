class CPathMover : public CPathSimple
{
	CUtlVector< CHandle< CMoverPathNode > > m_vecPathNodes;
	CTransform m_xInitialPathWorldToLocal;
	bool m_bClosedLoop;
};
