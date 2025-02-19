class CDOTA_Modifier_Legion_Commander_Duel
{
	int32 reward_damage;
	int32 assist_reward_damage;
	int32 damage_reduction_pct;
	int32 debuff_immunity;
	bool m_bAttacked;
	bool m_bHadAVictor;
	GameTime_t m_flTimeDuelStart;
	CHandle< CBaseEntity > m_hPartner;
	float32 m_flNextTime;
	CUtlVector< CHandle< CBaseEntity > > hAlreadyHitList;
	CUtlVector< CHandle< CBaseEntity > > m_hAllyAssisters;
	CUtlVector< CHandle< CBaseEntity > > m_hEnemyAssisters;
};
