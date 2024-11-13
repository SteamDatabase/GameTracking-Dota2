class CDOTA_Modifier_Luna_Eclipse : public CDOTA_Buff
{
	CHandle< CBaseEntity > m_hTarget;
	float32 radius;
	int32 beams;
	int32 hit_count;
	int32 m_iBeamDamage;
	float32 beam_interval;
	float32 stun_duration;
	Vector vPosition;
	bool bAreaTarget;
	int32 m_iTickCount;
	ParticleIndex_t m_nMoonlightFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_HitTargets;
	float32 m_flBeamStun;
};
