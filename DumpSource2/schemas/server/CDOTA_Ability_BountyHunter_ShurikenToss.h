class CDOTA_Ability_BountyHunter_ShurikenToss
{
	CHandle< CDOTABaseAbility > m_hSourceAbility;
	CHandle< CBaseEntity > m_hSourceCaster;
	CUtlVector< CHandle< CBaseEntity > > m_hHitEntities;
	bool passthrough_damage;
};
