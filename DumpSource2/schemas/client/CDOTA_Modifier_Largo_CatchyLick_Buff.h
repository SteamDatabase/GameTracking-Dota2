class CDOTA_Modifier_Largo_CatchyLick_Buff : public CDOTA_Buff
{
	float32 dispel_hp_regen;
	int32 num_purged;
	CHandle< C_BaseEntity > m_hDispelTarget;
	float32 m_fHealingDone;
};
