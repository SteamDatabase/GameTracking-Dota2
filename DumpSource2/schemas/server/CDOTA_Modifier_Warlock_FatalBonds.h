class CDOTA_Modifier_Warlock_FatalBonds : public CDOTA_Buff
{
	CUtlVector< CHandle< CBaseEntity > > m_FatalBondsEntities;
	int32 damage_share_percentage;
	float32 imp_duration;
}
