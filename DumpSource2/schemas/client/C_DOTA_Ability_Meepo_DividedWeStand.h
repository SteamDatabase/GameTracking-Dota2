// MNetworkVarNames = "int m_nWhichDividedWeStand"
// MNetworkVarNames = "int m_nNumDividedWeStand"
// MNetworkVarNames = "CHandle< CDOTA_Ability_Meepo_DividedWeStand> m_entPrimeDividedWeStand"
// MNetworkVarNames = "CHandle< CDOTA_Ability_Meepo_DividedWeStand> m_entNextDividedWeStand"
class C_DOTA_Ability_Meepo_DividedWeStand : public C_DOTABaseAbility
{
	// MNetworkEnable
	int32 m_nWhichDividedWeStand;
	// MNetworkEnable
	int32 m_nNumDividedWeStand;
	// MNetworkEnable
	CHandle< C_DOTA_Ability_Meepo_DividedWeStand > m_entPrimeDividedWeStand;
	// MNetworkEnable
	CHandle< C_DOTA_Ability_Meepo_DividedWeStand > m_entNextDividedWeStand;
};
