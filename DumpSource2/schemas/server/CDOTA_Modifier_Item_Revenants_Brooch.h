class CDOTA_Modifier_Item_Revenants_Brooch : public CDOTA_Buff_Item
{
	bool m_bScepter;
	int32 bonus_damage;
	int32 spell_lifesteal;
	int32 bonus_spell_lifesteal;
	int32 manacost_per_hit;
	bool m_bActive;
	CUtlVector< int16 > m_InFlightAttackRecords;
};
