class CDOTA_Ability_Nevermore_Requiem : public CDOTABaseAbility
{
	float32 requiem_line_width_start;
	float32 requiem_line_width_end;
	int32 m_nCachedSouls;
	ParticleIndex_t m_nFXIndex;
	int32 m_nKilleater_nLines;
	CUtlVector< CHandle< CBaseEntity > > m_vecHeroesReqd;
};
