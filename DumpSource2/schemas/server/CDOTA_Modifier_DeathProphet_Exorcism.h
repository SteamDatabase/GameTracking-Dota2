class CDOTA_Modifier_DeathProphet_Exorcism : public CDOTA_Buff
{
	float32 radius;
	int32 spirit_speed;
	int32 max_distance;
	int32 give_up_distance;
	int32 heal_percent;
	int32 spirit_duration;
	float32 ghost_spawn_rate;
	int32 movement_bonus;
	int32 m_iSpirits;
	GameTime_t m_fStartTime;
	GameTime_t m_fLastThinkTime;
	GameTime_t m_fSpawnTime;
	bool m_bFirstSpawn;
	bool m_bCommentedOnExpired;
	bool m_bForceExpired;
	CUtlVector< CHandle< CBaseEntity > > m_vecDeadHeroes;
	CUtlVector< sSpiritInfo* > m_vecSpirits;
};
