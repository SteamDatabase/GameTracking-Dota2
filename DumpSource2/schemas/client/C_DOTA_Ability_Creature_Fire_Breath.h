class C_DOTA_Ability_Creature_Fire_Breath : public C_DOTABaseAbility
{
	int32 speed;
	int32 projectile_count;
	float32 rotation_angle;
	float32 damage;
	float32 radius;
	CountdownTimer ctTimer;
	Vector m_vecStartRot;
	Vector m_vecEndRot;
}
