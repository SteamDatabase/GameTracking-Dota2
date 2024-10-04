class CDOTA_Unit_Nian : public CDOTA_BaseNPC_Creature
{
	CUtlVector< NianDamageTaken_t > m_vecRecentDamage;
	CHandle< CBaseEntity > m_hTail;
	CHandle< CBaseEntity > m_hHorn;
};
