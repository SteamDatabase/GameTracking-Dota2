class CDOTA_Modifier_Rattletrap_JetPack : public CDOTA_Buff
{
	int32 m_nMovementSpeed;
	int32 bonus_speed;
	float32 turn_rate;
	GameTime_t m_flStartTime;
	float32 tick_interval;
	float32 m_flFacingTarget;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< float32 > m_flTurnHistory;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHeroesHitLastRicochet;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHeroesCredited;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHeroesHitCurrentRicochet;
};
