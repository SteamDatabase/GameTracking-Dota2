class C_DOTA_Ability_Oracle_FortunesEnd : public C_DOTABaseAbility
{
	int32 damage;
	float32 radius;
	int32 bolt_speed;
	float32 maximum_purge_duration;
	float32 minimum_purge_duration;
	bool purge_constantly;
	GameTime_t m_flStartTime;
	float32 m_flDuration;
	float32 m_flDamage;
	bool m_bAbsorbed;
	CHandle< C_BaseEntity > m_hTarget;
	ParticleIndex_t m_nFXIndex;
};
