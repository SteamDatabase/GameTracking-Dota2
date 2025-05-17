// MNetworkVarNames = "bool m_bDisabled"
class CInfoPlayerStartDota : public CPointEntity
{
	// MNetworkEnable
	bool m_bDisabled;
	CEntityIOOutput m_OnEnabled;
	CEntityIOOutput m_OnDisabled;
};
