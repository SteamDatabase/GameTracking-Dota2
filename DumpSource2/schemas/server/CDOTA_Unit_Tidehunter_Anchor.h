// MNetworkVarNames = "CHandle< CBaseEntity> m_hTarget"
// MNetworkVarNames = "Vector m_vProjectilePosition"
class CDOTA_Unit_Tidehunter_Anchor : public CDOTA_BaseNPC_Additive
{
	// MNetworkEnable
	CHandle< CBaseEntity > m_hTarget;
	// MNetworkEnable
	Vector m_vProjectilePosition;
};
