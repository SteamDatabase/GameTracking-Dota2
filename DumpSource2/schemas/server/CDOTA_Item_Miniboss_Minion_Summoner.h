// MNetworkVarNames = "bool m_bItemActivated"
class CDOTA_Item_Miniboss_Minion_Summoner : public CDOTA_Item
{
	GameTime_t m_fEquipTime;
	GameTime_t m_flActivatedTime;
	CHandle< CBaseEntity > m_hOwner;
	// MNetworkEnable
	bool m_bItemActivated;
};
