class CDOTA_Modifier_Seasonal_PartyHat : public CDOTA_Buff
{
	int32 controlled_unit_search_radius;
	bool child_modifier;
	CUtlString m_strEffectName;
	ParticleIndex_t m_nHatFXIndex;
	CUtlVector< int32 > m_vecHatColors;
	uint32 m_unVersion;
	CUtlVector< CHandle< CBaseEntity > > m_vecNearbyUnits;
	CUtlVector< GameTime_t > m_vecUnitIdleStartTimes;
	bool m_bPlayEndcapOnNext;
};
