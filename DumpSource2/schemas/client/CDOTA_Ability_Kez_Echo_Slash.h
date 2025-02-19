class CDOTA_Ability_Kez_Echo_Slash
{
	Vector m_vInitialDirection;
	Vector m_vStartPos;
	CTransform m_InitialTransform;
	int32 katana_radius;
	int32 katana_distance;
	int32 travel_distance;
	int32 katana_strikes;
	int32 katana_echo_damage;
	float32 strike_interval;
	float32 effect_duration;
	int32 m_nStrikesLeft;
	GameTime_t m_NextStrikeTime;
	bool m_bFlutter;
	ParticleIndex_t m_nFXCast;
};
