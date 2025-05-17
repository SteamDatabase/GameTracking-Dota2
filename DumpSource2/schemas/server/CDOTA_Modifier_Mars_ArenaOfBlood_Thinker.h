class CDOTA_Modifier_Mars_ArenaOfBlood_Thinker : public CDOTA_Buff
{
	float32 radius;
	float32 formation_time;
	float32 m_flInitialZ;
	float32 m_flFinalZ;
	bool m_bCaughtOne;
	bool m_bKilledOne;
	CUtlVector< CHandle< CBaseEntity > > m_vecVisionBlockers;
};
