class CDOTA_Modifier_Shredder_Flamethrower_TreeFire_Thinker : public CDOTA_Buff
{
	CUtlVector< std::pair< CHandle< C_BaseEntity >, GameTime_t > > m_vecTreeFires;
	bool m_bCleanupWhenEmpty;
};
