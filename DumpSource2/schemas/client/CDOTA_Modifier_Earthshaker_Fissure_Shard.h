class CDOTA_Modifier_Earthshaker_Fissure_Shard : public CDOTA_Buff
{
	int32 shard_aftershock_stun_duration_pct;
	float32 shard_free_pathing_linger_duration;
	float32 fissure_movement_speed;
	float32 fissure_max_distance_moved;
	Vector m_vStartPos;
	Vector m_vEndPos;
	Vector m_vMoveDir;
	float32 m_flTotalDistanceMoved;
};
