class CDOTA_Modifier_Marci_Bodyguarded : public CDOTA_Buff
{
	int32 bodyguard_attack_range_buffer;
	float32 lifesteal_pct;
	int32 bonus_damage;
	int32 max_partner_penalty;
	int32 creep_lifesteal_reduction_pct;
	int32 shared_healing_percent;
	float32 counter_cooldown;
	GameTime_t m_flLastCounterTime;
	bool bHasCountered;
};
