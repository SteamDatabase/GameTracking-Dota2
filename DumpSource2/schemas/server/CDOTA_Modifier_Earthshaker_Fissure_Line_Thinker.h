class CDOTA_Modifier_Earthshaker_Fissure_Line_Thinker : public CDOTA_Buff
{
	int32 fissure_radius;
	float32 fissure_movement_speed;
	float32 stun_duration;
	float32 fissure_damage;
	float32 free_pathing_linger_duration;
	float32 fissure_max_distance_moved;
	GameTime_t m_flLastThinkTime;
	Vector m_vFissureStart;
	Vector m_vFissureStep;
	Vector m_vMoveDir;
	int32 m_nSegments;
	float32 m_flDurationOriginal;
	float32 m_flTotalDistanceMoved;
	ParticleIndex_t m_nFissureEffectIndex;
	CUtlVector< CDOTA_BaseNPC* > thinkerEntities;
};
