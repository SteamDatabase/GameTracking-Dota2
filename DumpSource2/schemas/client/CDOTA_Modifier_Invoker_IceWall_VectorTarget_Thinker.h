class CDOTA_Modifier_Invoker_IceWall_VectorTarget_Thinker : public CDOTA_Buff
{
	int32 slow;
	float32 slow_duration;
	float32 root_duration;
	float32 damage_per_second;
	float32 root_damage;
	float32 tick_interval;
	int32 wall_total_length;
	int32 wall_width;
	Vector m_vWallCenter;
	Vector m_vWallDirection;
	Vector m_vWallRight;
	Vector m_vWallLeft;
	ParticleIndex_t m_nParticleIndexA;
	ParticleIndex_t m_nParticleIndexB;
	bool m_bStartedExpanding;
	float32 glacier_formation_speed;
	GameTime_t m_flFormationStartTime;
	bool m_bGrantedGem;
	CUtlVector< CHandle< C_BaseEntity > > m_vecEnemiesInWall;
};
