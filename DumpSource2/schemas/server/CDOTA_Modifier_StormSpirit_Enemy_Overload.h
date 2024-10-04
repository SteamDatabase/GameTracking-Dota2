class CDOTA_Modifier_StormSpirit_Enemy_Overload : public CDOTA_Buff
{
	float32 overload_aoe;
	CUtlVector< CHandle< CBaseEntity > > m_vecHitUnits;
	int32 m_nAttackRecordIndex;
}
