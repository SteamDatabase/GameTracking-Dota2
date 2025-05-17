class CDOTA_Modifier_TrollWarlord_BattleTrance : public CDOTA_Buff
{
	int32 movement_speed;
	int32 slow_resistance;
	int32 attack_speed;
	int32 lifesteal;
	int32 ignore_attack_speed_limit;
	CHandle< CBaseEntity > m_hTarget;
};
