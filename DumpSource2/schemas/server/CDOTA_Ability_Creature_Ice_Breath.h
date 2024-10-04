class CDOTA_Ability_Creature_Ice_Breath : public CDOTABaseAbility
{
	int32 speed;
	int32 projectile_count;
	float32 rotation_angle;
	float32 damage;
	float32 radius;
	float32 slow_duration;
	CountdownTimer ctTimer;
	Vector m_vecStartRot;
	Vector m_vecEndRot;
};
