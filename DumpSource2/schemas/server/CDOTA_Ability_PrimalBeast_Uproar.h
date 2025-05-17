// MNetworkVarNames = "int m_iUproarStatus"
class CDOTA_Ability_PrimalBeast_Uproar : public CDOTABaseAbility
{
	// MNetworkEnable
	// MNetworkChangeCallback = "OnUproarActiveChanged"
	int32 m_iUproarStatus;
	bool m_bUpdateIcons;
};
