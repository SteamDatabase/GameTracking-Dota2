class CDOTA_Modifier_StormSpirit_StaticRemnantThinker : public CDOTA_Buff
{
	float32 static_remnant_radius;
	float32 static_remnant_damage_radius;
	float32 static_remnant_damage;
	float32 static_remnant_delay;
	float32 static_remnant_travel_speed;
	int32 m_iSearchRadius;
	int32 m_iDamageRadius;
	bool m_bDoesMove;
	bool m_bReachedTargetLocation;
	Vector m_vTargetLocation;
	GameTime_t m_flCreateTime;
	GameTime_t m_flLastMoveTime;
};
