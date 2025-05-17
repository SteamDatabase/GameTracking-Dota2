class CDOTA_Modifier_Batrider_Firefly : public CDOTA_Buff
{
	bool m_bActive;
	float32 radius;
	int32 m_ifirefly_Active;
	float32 tree_radius;
	float32 damage_per_second;
	float32 movement_speed;
	int32 bonus_slow_resistance;
	float32 tick_interval;
	ParticleIndex_t m_nFXIndex;
	ParticleIndex_t m_nFXIndexB;
	GameTime_t m_fNextDamageTick;
	Vector m_vLastFirePoolLoc;
	int32 bonus_vision;
};
