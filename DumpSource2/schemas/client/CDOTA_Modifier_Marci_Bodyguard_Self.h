class CDOTA_Modifier_Marci_Bodyguard_Self : public CDOTA_Buff
{
	float32 lifesteal_pct;
	int32 bonus_damage;
	int32 creep_lifesteal_reduction_pct;
	int32 shared_healing_percent;
	CHandle< C_BaseEntity > m_hPartner;
};
