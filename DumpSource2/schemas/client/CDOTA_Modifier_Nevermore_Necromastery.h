class CDOTA_Modifier_Nevermore_Necromastery : public CDOTA_Buff
{
	int32 souls_per_kill;
	int32 souls_per_hero_kill;
	int32 necromastery_damage_per_soul;
	int32 necromastery_max_souls;
	int32 max_soul_increase_on_hero_kill;
	int32 shard_crit_pct;
	int32 shard_souls_per_kill;
	float32 shard_fear_duration;
	int32 m_nPermanentMaxSouls;
	ParticleIndex_t m_iParticleSoulsIndex;
	ParticleIndex_t m_FXIndex;
	CUtlVector< int16 > m_InFlightAttackRecords;
};
