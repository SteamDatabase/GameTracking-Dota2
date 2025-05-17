class CDOTA_Modifier_DeathProphet_Scepter : public CDOTA_Buff
{
	float32 radius;
	float32 spirit_speed;
	float32 max_distance;
	float32 give_up_distance;
	float32 min_damage;
	float32 max_damage;
	int32 heal_percent;
	int32 spirit_duration;
	GameTime_t m_fStartTime;
	GameTime_t m_fLastThinkTime;
	bool m_bExpired;
	sSpiritInfo* m_SpiritInfo;
};
