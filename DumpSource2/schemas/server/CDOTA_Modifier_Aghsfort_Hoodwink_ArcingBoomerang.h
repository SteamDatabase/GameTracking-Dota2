class CDOTA_Modifier_Aghsfort_Hoodwink_ArcingBoomerang : public CDOTA_Buff
{
	Vector m_vLeftControl;
	Vector m_vRightControl;
	Vector m_vTargetLoc;
	VectorWS m_vOriginalTargetLoc;
	Vector m_vSourceLoc;
	float32 m_flBuffDuration;
	GameTime_t m_flBuffDieTime;
	bool m_bReturning;
	int32 m_nFramesToWait;
	CHandle< CBaseEntity > m_hBoomerang;
	ParticleIndex_t m_nBoomerangFXIndex;
	ParticleIndex_t m_nOldBoomerangFXindex;
	CUtlVector< CHandle< CBaseEntity > > m_vecUniqueHitList;
	int32 radius;
	int32 spread;
	int32 damage;
	float32 min_throw_duration;
	float32 max_throw_duration;
};
