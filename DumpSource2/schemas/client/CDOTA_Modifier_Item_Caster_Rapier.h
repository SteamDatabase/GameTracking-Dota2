class CDOTA_Modifier_Item_Caster_Rapier : public CDOTA_Buff_Item
{
	int32 cast_range_limit;
	int32 bonus_spell_amp;
	int32 backstab_duration;
	CUtlVector< int16 > m_InFlightAttackRecords;
}
