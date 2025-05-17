// MNetworkVarNames = "EHANDLE m_hBear"
class CDOTA_Ability_LoneDruid_SpiritBear : public CDOTABaseAbility
{
	bool m_bLevelChanged;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hBear;
	CHandle< CBaseEntity > m_hPreBear;
};
