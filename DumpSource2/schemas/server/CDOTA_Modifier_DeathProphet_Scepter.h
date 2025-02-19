class CDOTA_Modifier_DeathProphet_Scepter
{
	int32 radius;
	int32 spirit_speed;
	int32 max_distance;
	int32 give_up_distance;
	int32 min_damage;
	int32 max_damage;
	int32 heal_percent;
	int32 spirit_duration;
	GameTime_t m_fStartTime;
	GameTime_t m_fLastThinkTime;
	bool m_bExpired;
	sSpiritInfo* m_SpiritInfo;
};
