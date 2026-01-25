class CDOTA_Ability_Pangolier_Swashbuckle : public CDOTABaseAbility, public CHorizontalMotionController
{
	float32 dash_speed;
	float32 start_radius;
	float32 end_radius;
	float32 range;
	float32 damage;
	float32 attack_damage;
	int32 procs_onhit_effects;
	float32 slow_duration;
	Vector m_vDashPosition;
	Vector m_vFacePosition;
	Vector m_vEndpoint;
	Vector m_vSlashDir;
	int32 m_nDashProjectileID;
	Vector m_vDashProjectileLocation;
};
