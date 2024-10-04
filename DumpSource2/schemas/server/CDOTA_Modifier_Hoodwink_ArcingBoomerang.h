class CDOTA_Modifier_Hoodwink_ArcingBoomerang : public CDOTA_Buff
{
	Vector m_vLeftControl;
	Vector m_vRightControl;
	Vector m_vTargetLoc;
	Vector m_vOriginalTargetLoc;
	Vector m_vSourceLoc;
	bool m_bGroundTargeted;
	float32 m_flTravelDuration;
	GameTime_t m_flBoomerangDieTime;
	bool m_bReturning;
	bool m_bCatchingBoomerang;
	bool m_bDisjointed;
	int32 m_nFramesToWait;
	CHandle< CBaseEntity > m_hBoomerang;
	CHandle< CBaseEntity > m_hTarget;
	ParticleIndex_t m_nBoomerangFXIndex;
	ParticleIndex_t m_nOldBoomerangFXindex;
	CUtlVector< CHandle< CBaseEntity > > m_vecUniqueHitList;
	int32 radius;
	int32 spread;
	int32 damage;
	float32 mark_duration;
	float32 min_throw_duration;
	float32 max_throw_duration;
};
