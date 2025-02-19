class CDOTA_Modifier_TemplarAssassin_Meld
{
	int32 bonus_damage;
	bool launched_attack;
	CHandle< CBaseEntity > m_hTarget;
	int32 m_nAttackRecord;
	float32 attack_range_smoothness;
	int32 attack_range_increase_max;
	float32 attack_range_increase_time;
	float32 m_fAttackRangeIncreaseSpeed;
	int32 m_iTotalAttackRangeAmount;
	ParticleIndex_t m_nFXIndexAoE;
};
