class CDOTA_Ability_Magnataur_Skewer
{
	float32 skewer_radius;
	int32 skewer_speed;
	int32 tree_radius;
	int32 tree_hit_damage;
	int32 cliff_hit_damage;
	int32 terrain_hit_increase_pct;
	float32 terrain_hit_cooldown;
	int32 m_nProjectileID;
	int32 m_nVisibleTargetCount;
	CUtlVector< CHandle< CBaseEntity > > m_hEnemiesSkewered;
	GameTime_t m_flLastTerrainObstructionHitTime;
	int32 m_nTargetsHit;
};
