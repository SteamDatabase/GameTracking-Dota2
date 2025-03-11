class CDOTA_Ability_Broodmother_StickySnare
{
	Vector m_vEndpoint;
	float32 duration;
	float32 width;
	bool m_bStolenSnareCheck;
	CUtlVector< CHandle< C_BaseEntity > > m_vecSnares;
};
