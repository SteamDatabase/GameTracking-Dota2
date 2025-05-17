// MNetworkVarNames = "EHANDLE m_hBear"
class C_DOTA_Ability_LoneDruid_SpiritBear : public C_DOTABaseAbility
{
	bool m_bLevelChanged;
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hBear;
	CHandle< C_BaseEntity > m_hPreBear;
};
