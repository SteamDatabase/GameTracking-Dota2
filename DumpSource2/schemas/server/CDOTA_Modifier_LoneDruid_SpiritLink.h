class CDOTA_Modifier_LoneDruid_SpiritLink : public CDOTA_Buff
{
	int32 bonus_attack_speed;
	int32 lifesteal_percent;
	int32 armor;
	int32 armor_sharing;
	int32 active_bonus;
	int32 lifesteal_both_ways;
	CHandle< CBaseEntity > m_hTarget;
};
