class CDOTA_Modifier_Marci_Bodyguarded : public CDOTA_Buff
{
	ParticleIndex_t m_nFxIndex;
	int32 bodyguard_attack_range_buffer;
	int32 bonus_armor;
	float32 counter_cooldown;
	GameTime_t m_flLastCounterTime;
	bool bHasCountered;
};
