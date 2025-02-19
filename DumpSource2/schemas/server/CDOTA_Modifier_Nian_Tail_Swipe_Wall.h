class CDOTA_Modifier_Nian_Tail_Swipe_Wall
{
	Vector m_vWallStartPosition;
	Vector m_vWallDirection;
	Vector m_vWallLeft;
	int32 m_DamageAmount;
	int32 m_DamageType;
	float32 speed;
	float32 starting_width;
	float32 ending_width;
	float32 stun_duration;
	float32 fly_duration;
	float32 fly_distance;
	ParticleIndex_t m_nFXIndex;
	GameTime_t m_flWallStartTime;
	float32 m_flScalar;
	CUtlVector< CHandle< CBaseEntity > > m_EntitiesToExclude;
};
