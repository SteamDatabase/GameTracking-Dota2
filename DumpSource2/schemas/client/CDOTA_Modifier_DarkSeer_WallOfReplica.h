class CDOTA_Modifier_DarkSeer_WallOfReplica : public CDOTA_Buff
{
	Vector m_vWallDirection;
	Vector m_vWallRight;
	CUtlOrderedMap< int32, GameTime_t > m_PreventReplicateTime;
	int32 width;
	int32 wall_damage;
	float32 slow_duration;
	int32 replica_damage_incoming;
	int32 replica_damage_outgoing;
}
