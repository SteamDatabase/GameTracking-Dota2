class CDOTA_Ability_Warlock_Upheaval : public CDOTABaseAbility
{
	Vector m_vPosition;
	float32 aoe;
	int32 slow_per_second;
	int32 aspd_per_second;
	int32 max_slow;
	int32 base_damage;
	int32 damage_per_second;
	int32 max_damage;
	float32 damage_tick_interval;
	CountdownTimer m_timer;
	CountdownTimer m_shardTimer;
	float32 duration;
	GameTime_t m_flElapsedTime;
	float32 m_flCurrentSlow;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nCastFXIndex;
	bool m_bTargetCast;
	CHandle< CBaseEntity > m_hTarget;
};
