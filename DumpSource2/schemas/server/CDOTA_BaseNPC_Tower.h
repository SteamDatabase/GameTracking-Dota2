// MNetworkVarNames = "EHANDLE m_hTowerAttackTarget"
// MNetworkVarNames = "EHANDLE m_hTowerHighFiveTarget"
class CDOTA_BaseNPC_Tower : public CDOTA_BaseNPC_Building
{
	CEntityIOOutput m_OnTowerKilled;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hTowerAttackTarget;
	// MNetworkEnable
	CHandle< CBaseEntity > m_hTowerHighFiveTarget;
};
