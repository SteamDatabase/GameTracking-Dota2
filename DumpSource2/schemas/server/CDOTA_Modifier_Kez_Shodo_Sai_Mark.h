class CDOTA_Modifier_Kez_Shodo_Sai_Mark : public CDOTA_Buff
{
	int32 vuln_slow;
	int32 base_crit_pct;
	int32 parry_bonus_crit;
	int32 invis_bonus_crit;
	float32 stun_duration;
	float32 parry_stun_duration;
	CUtlVector< int16 > m_vecAttackRecords;
	bool m_bFromParry;
	bool m_bParryBonus;
	bool m_bConsumed;
	bool m_bForceInvisBonus;
	ParticleIndex_t m_nOverheadFXIndex;
};
