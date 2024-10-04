class CLocalNPCObstructionsCache
{
	GameTick_t m_nLastUpdatedTick;
	float32 m_flRadius;
	CUtlVector< CHandle< CDOTA_BaseNPC > > m_hCachedNPCs;
}
