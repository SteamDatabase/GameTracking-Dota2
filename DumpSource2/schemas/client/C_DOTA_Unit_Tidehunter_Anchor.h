// MNetworkVarNames = "CHandle< CBaseEntity> m_hTarget"
// MNetworkVarNames = "Vector m_vProjectilePosition"
class C_DOTA_Unit_Tidehunter_Anchor : public C_DOTA_BaseNPC_Additive
{
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hTarget;
	// MNetworkEnable
	Vector m_vProjectilePosition;
};
