class CDOTA_Modifier_Broodmother_StickySnare : public CDOTA_Buff
{
	Vector m_vOrigin;
	Vector m_vWallDirection;
	Vector m_vWallRight;
	int32 width;
	float32 root_duration;
	float32 formation_delay;
	bool m_bTouching;
	CHandle< CBaseEntity > m_hRight;
	bool m_bParticle;
	GameTime_t m_flStartingTime;
	int32 m_nFoWID;
	int32 m_nTeamID;
	CUtlVector< CHandle< CBaseEntity > > m_vecAffectedHeroes;
	ParticleIndex_t m_nWarmupFXIndex;
};
