class CDOTA_Modifier_Beastmaster_CallOfTheWild_Hawk : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hOwner;
	int32 attack_radius;
	GameTime_t m_flLastAttack;
	float32 roaming_seconds_per_rotation;
	int32 roaming_radius;
	float32 attack_interval;
	int32 min_move_speed;
	int32 max_move_speed;
	int32 m_iPreviousHawkCount;
	float32 m_flRotation;
};
