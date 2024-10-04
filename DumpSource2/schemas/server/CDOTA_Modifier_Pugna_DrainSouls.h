class CDOTA_Modifier_Pugna_DrainSouls : public CDOTA_Buff
{
	float32 health_drain_death_boost;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_vecDrainedHeroes;
}
