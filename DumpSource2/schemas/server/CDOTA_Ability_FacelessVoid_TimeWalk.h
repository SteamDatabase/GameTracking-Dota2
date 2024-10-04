class CDOTA_Ability_FacelessVoid_TimeWalk : public CDOTABaseAbility
{
	CHandle< CDOTABaseAbility > m_hSourceAbility;
	int32 speed;
	int32 range;
	int32 radius;
	int32 m_nProjectileID;
	Vector m_vProjectileLocation;
	Vector m_vStartLocation;
}
