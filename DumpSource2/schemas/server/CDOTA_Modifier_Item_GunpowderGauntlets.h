class CDOTA_Modifier_Item_GunpowderGauntlets : public CDOTA_Buff_Item
{
	float32 bonus_damage;
	float32 splash_radius;
	float32 splash_pct;
	CUtlVector< int16 > m_InFlightAttackRecords;
};
