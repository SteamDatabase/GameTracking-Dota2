// MNetworkVarNames = "CHandle< CBaseEntity> m_hTarget"
class CDOTA_Ability_Aghsfort_Elemental_Wisp_Tether : public CDOTABaseAbility
{
	// MNetworkEnable
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vProjectileLocation;
	bool m_bProjectileActive;
	int32 latch_distance;
	int32 m_iProjectileIndex;
};
