class CDOTA_BaseNPC_Tower : public CDOTA_BaseNPC_Building
{
	CEntityIOOutput m_OnTowerKilled;
	CHandle< CBaseEntity > m_hTowerAttackTarget;
	CHandle< CBaseEntity > m_hTowerHighFiveTarget;
};
