// MNetworkVarNames = "int16 m_nRadiantCheers"
// MNetworkVarNames = "int16 m_nDireCheers"
// MNetworkVarNames = "int16 m_nRadiantPremiumCheers"
// MNetworkVarNames = "int16 m_nDirePremiumCheers"
// MNetworkVarNames = "ECrowdLevel m_nRadiantCrowdLevel"
// MNetworkVarNames = "ECrowdLevel m_nDireCrowdLevel"
class C_DOTACheers : public C_BaseEntity
{
	// MNetworkEnable
	int16 m_nRadiantCheers;
	// MNetworkEnable
	int16 m_nDireCheers;
	// MNetworkEnable
	int16 m_nRadiantPremiumCheers;
	// MNetworkEnable
	int16 m_nDirePremiumCheers;
	// MNetworkEnable
	ECrowdLevel m_nRadiantCrowdLevel;
	// MNetworkEnable
	ECrowdLevel m_nDireCrowdLevel;
};
