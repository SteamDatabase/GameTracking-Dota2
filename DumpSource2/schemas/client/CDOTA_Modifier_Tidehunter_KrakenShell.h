class CDOTA_Modifier_Tidehunter_KrakenShell : public CDOTA_Buff
{
	int32 m_iDamageTaken;
	int32 damage_reduction;
	int32 bonus_reduction_per_kill;
	float32 creep_reduction_penalty_pct;
	float32 active_pct_effectiveness;
};
