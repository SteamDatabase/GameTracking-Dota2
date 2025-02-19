class C_DOTA_Ability_EarthSpirit_RollingBoulder
{
	int32 radius;
	int32 speed;
	int32 rock_speed;
	int32 damage;
	int32 damage_str;
	float32 distance;
	float32 rock_distance;
	float32 rock_distance_multiplier;
	float32 slow_duration;
	int32 destroy_stone;
	bool can_roll_over_allied_heroes;
	float32 allied_hero_multiplier;
	float32 allied_hero_distance;
	float32 allied_hero_speed;
	ParticleIndex_t m_nFXIndex;
	bool m_boulderSetposBool;
	int32 m_nProjectileID;
	Vector m_vStartingLocation;
	Vector m_vProjectileLocation;
	Vector m_vDir;
	Vector m_vVel;
	bool m_bUsedStone;
	bool m_bRolledOverAlliedHero;
	Vector m_vRollDirection;
};
