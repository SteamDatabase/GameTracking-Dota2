class CDOTA_Modifier_StormSpirit_Overload : public CDOTA_Buff
{
	float32 overload_aoe;
	float32 overload_cast_range;
	CUtlVector< CHandle< C_BaseEntity > > m_vecHitUnits;
}
