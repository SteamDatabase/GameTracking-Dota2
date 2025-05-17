class CDOTA_Modifier_NightStalker_HunterInTheNight : public CDOTA_Buff
{
	int32 bonus_movement_speed_pct_night;
	int32 bonus_attack_speed_night;
	int32 bonus_status_resist_night;
	ParticleIndex_t m_nFXIndex;
	bool m_bIsDay;
};
