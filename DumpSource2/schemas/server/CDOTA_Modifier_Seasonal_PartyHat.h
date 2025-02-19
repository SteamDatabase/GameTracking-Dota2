class CDOTA_Modifier_Seasonal_PartyHat
{
	int32 controlled_unit_search_radius;
	bool child_modifier;
	CUtlVector< ParticleIndex_t > m_vecParticles;
	CUtlVector< int32 > m_vecHatColors;
	uint32 m_unVersion;
	CUtlVector< CHandle< CBaseEntity > > m_vecNearbyUnits;
	CUtlVector< GameTime_t > m_vecUnitIdleStartTimes;
	bool m_bPlayEndcapOnNext;
};
