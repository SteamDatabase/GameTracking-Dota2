class CDOTA_Ability_Kez_Echo_Slash
{
	Vector m_vInitialDirection;
	Vector m_vStartPos;
	CTransform m_InitialTransform;
	float32 katana_radius;
	float32 katana_distance;
	float32 travel_distance;
	int32 katana_strikes;
	float32 katana_echo_damage;
	float32 strike_interval;
	float32 effect_duration;
	int32 m_nStrikesLeft;
	GameTime_t m_NextStrikeTime;
	bool m_bFlutter;
	ParticleIndex_t m_nFXCast;
};
