// MNetworkVarNames = "CPathQueryComponent::Storage_t m_CPathQueryComponent"
class CPathMover : public CBaseEntity
{
	// MNetworkEnable
	// MNetworkUserGroup = "CPathQueryComponent"
	// MNetworkAlias = "CPathQueryComponent"
	// MNetworkTypeAlias = "CPathQueryComponent"
	CPathQueryComponent m_CPathQueryComponent;
	CUtlVector< CHandle< CMoverPathNode > > m_vecPathNodes;
	CTransform m_xInitialPathWorldToLocal;
	bool m_bClosedLoop;
};
