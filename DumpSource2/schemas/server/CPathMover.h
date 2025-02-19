class CPathMover
{
	CPathQueryComponent m_CPathQueryComponent;
	CUtlVector< CHandle< CMoverPathNode > > m_vecPathNodes;
	CTransform m_xInitialPathWorldToLocal;
	bool m_bClosedLoop;
};
