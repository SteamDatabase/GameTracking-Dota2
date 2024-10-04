class CDOTA_Modifier_Shredder_Flamethrower_TreeFire_Thinker : public CDOTA_Buff
{
	CUtlVector< CUtlPair< CHandle< CBaseEntity >, GameTime_t > > m_vecTreeFires;
	bool m_bCleanupWhenEmpty;
}
