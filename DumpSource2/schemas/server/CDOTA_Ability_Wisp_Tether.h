class CDOTA_Ability_Wisp_Tether : public CDOTABaseAbility
{
	CHandle< CBaseEntity > m_hTarget;
	Vector m_vProjectileLocation;
	bool m_bProjectileActive;
	int32 latch_distance;
	int32 m_iProjectileIndex;
}
