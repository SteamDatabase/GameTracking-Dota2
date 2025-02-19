class CDOTA_Modifier_Shredder_TwistedChakram
{
	Vector m_vControlOne;
	Vector m_vControlTwo;
	Vector m_vControlThree;
	Vector m_vControlFour;
	Vector m_vTargetLoc;
	Vector m_vOriginalTargetLoc;
	Vector m_vSourceLoc;
	Vector m_vMidPoint;
	Vector m_vEndPoint;
	int32 m_nCurrentLeg;
	float32 m_flTravelDuration;
	GameTime_t m_flBoomerangDieTime;
	bool m_bReturning;
	int32 m_nFramesToWait;
	CHandle< CBaseEntity > m_hChakram;
	ParticleIndex_t m_nChakramFXIndex;
	ParticleIndex_t m_nOldChakramFXindex;
	CUtlVector< CHandle< CBaseEntity > > m_vecUniqueHitList;
	float32 radius;
	int32 spread;
	int32 damage;
	float32 pass_slow_duration;
	float32 min_throw_duration;
	float32 max_throw_duration;
};
