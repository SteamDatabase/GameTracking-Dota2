class CDOTA_Modifier_TemplarAssassin_Meld : public CDOTA_Buff
{
	int32 bonus_damage;
	bool launched_attack;
	CHandle< C_BaseEntity > m_hTarget;
	int32 m_nAttackRecord;
	int32 attack_range_increase_max;
	float32 attack_range_increase_time;
	float32 m_fAttackRangeIncreaseSpeed;
	ParticleIndex_t m_nFXIndexAoE;
	float32 m_fElapsedTime;
};
