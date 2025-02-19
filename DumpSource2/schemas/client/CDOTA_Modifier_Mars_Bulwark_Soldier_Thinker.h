class CDOTA_Modifier_Mars_Bulwark_Soldier_Thinker
{
	GameTime_t m_NextAttack;
	int32 soldier_offset;
	int32 soldier_count;
	int32 forward_angle;
	int32 knockback_distance;
	CUtlVector< CHandle< C_BaseEntity > > m_hAllSoldiers;
	GameTime_t m_flLastStationaryTime;
	Vector m_vLastStationaryPosition;
	float32 stationary_attack_delay;
};
