class CDOTA_Modifier_Meepo_Poof_Damage_Sharing : public CDOTA_Buff
{
	int32 damage_share_percentage;
	int32 damage_share_radius;
	CUtlVector< CHandle< CBaseEntity > > m_BondedEntities;
}
