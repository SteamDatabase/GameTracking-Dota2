// MNetworkVarNames = "CHandle< CBaseEntity> m_hTarget"
class C_DOTA_Ability_Wisp_Tether : public C_DOTABaseAbility
{
	// MNetworkEnable
	CHandle< C_BaseEntity > m_hTarget;
	Vector m_vProjectileLocation;
	bool m_bProjectileActive;
	int32 latch_distance;
	int32 m_iProjectileIndex;
};
