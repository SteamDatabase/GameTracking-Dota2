class CDOTA_Modifier_Marci_Bodyguard_Self : public CDOTA_Buff
{
	float32 lifesteal_pct;
	int32 bonus_damage;
	int32 creep_lifesteal_reduction_pct;
	CHandle< CBaseEntity > m_hPartner;
};
