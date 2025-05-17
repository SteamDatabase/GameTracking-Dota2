class CDOTA_Modifier_Enchantress_Little_Friends_Aura : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hTarget;
	int32 m_nAlliesTaunted;
	bool m_bRelicTriggered;
	float32 radius;
	int32 damage_amplification;
	int32 damage_reduction;
	float32 root_base_duration;
	float32 root_per_target;
	float32 max_root;
	GameTime_t m_flLastSeen;
};
