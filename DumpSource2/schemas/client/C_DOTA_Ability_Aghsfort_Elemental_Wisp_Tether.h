class C_DOTA_Ability_Aghsfort_Elemental_Wisp_Tether : public C_DOTABaseAbility
{
	CHandle< C_BaseEntity > m_hTarget;
	Vector m_vProjectileLocation;
	bool m_bProjectileActive;
	int32 latch_distance;
	int32 m_iProjectileIndex;
}
