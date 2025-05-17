// MNetworkVarNames = "int m_nWhichDividedWeStand"
// MNetworkVarNames = "int m_nNumDividedWeStand"
// MNetworkVarNames = "CHandle< CDOTA_Ability_Meepo_DividedWeStand> m_entPrimeDividedWeStand"
// MNetworkVarNames = "CHandle< CDOTA_Ability_Meepo_DividedWeStand> m_entNextDividedWeStand"
class CDOTA_Ability_Meepo_DividedWeStand : public CDOTABaseAbility
{
	// MNetworkEnable
	int32 m_nWhichDividedWeStand;
	// MNetworkEnable
	int32 m_nNumDividedWeStand;
	// MNetworkEnable
	CHandle< CDOTA_Ability_Meepo_DividedWeStand > m_entPrimeDividedWeStand;
	// MNetworkEnable
	CHandle< CDOTA_Ability_Meepo_DividedWeStand > m_entNextDividedWeStand;
	int32 m_iPendingUpgrades;
};
