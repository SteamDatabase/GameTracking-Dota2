class CDOTA_Modifier_Clinkz_Strafe_Debuff : public CDOTA_Buff
{
	int32 blind_pct;
	CUtlVector< CHandle< CBaseEntity > > m_hAppliers;
};
