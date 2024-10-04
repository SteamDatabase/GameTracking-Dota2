class CDOTA_Ability_Pangolier_Swashbuckle : public CDOTABaseAbility
{
	int32 dash_speed;
	int32 start_radius;
	int32 end_radius;
	int32 range;
	int32 damage;
	int32 attack_damage;
	int32 procs_onhit_effects;
	Vector m_vDashPosition;
	Vector m_vFacePosition;
	Vector m_vEndpoint;
	Vector m_vSlashDir;
	int32 m_nDashProjectileID;
	Vector m_vDashProjectileLocation;
};
