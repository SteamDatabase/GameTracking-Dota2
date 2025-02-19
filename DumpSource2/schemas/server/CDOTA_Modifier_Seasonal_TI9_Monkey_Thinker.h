class CDOTA_Modifier_Seasonal_TI9_Monkey_Thinker
{
	float32 attack_range;
	float32 attack_time;
	float32 attack_projectile_time;
	int32 projectile_speed;
	float32 turn_time;
	float32 turn_angle;
	float32 shoot_angle;
	float32 m_flTurnRate;
	float32 m_flTargetYaw;
	float32 m_flLastTurnTime;
	GameTick_t m_nLastTickCount;
	bool m_bHappyMonkeyCondition;
	CHandle< CDOTA_BaseNPC > m_hAngryTarget;
	CHandle< CDOTA_BaseNPC > m_hAttackTarget;
	CountdownTimer m_AttackTimer;
	CountdownTimer m_AttackProjectileTimer;
	CountdownTimer m_HappyTimer;
};
