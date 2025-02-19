class CDOTA_Modifier_Seasonal_TI11_RockPaperScissors
{
	float32 challenge_duration;
	float32 reveal_duration;
	float32 reveal_delay;
	float32 completed_cooldown;
	float32 think_interval;
	float32 acknowledge_range;
	GameTime_t m_flRevealTime;
	bool m_bFirstThink;
	PlayerID_t m_nRevealOpponentPlayerID;
};
