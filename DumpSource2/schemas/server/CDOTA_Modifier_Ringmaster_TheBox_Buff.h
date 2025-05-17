class CDOTA_Modifier_Ringmaster_TheBox_Buff : public CDOTA_Buff
{
	int32 leash_radius;
	Vector m_vLeashLocation;
	float32 transform_time;
	float32 invis_duration;
	int32 radius;
	int32 move_speed;
	int32 magic_resist;
	int32 grant_flying;
	int32 grant_debuff_immunity;
	float32 slow_resist;
	float32 m_flDamageTaken;
	GameTime_t m_flCancelTime;
	ParticleIndex_t m_nCircleFXIndex;
};
