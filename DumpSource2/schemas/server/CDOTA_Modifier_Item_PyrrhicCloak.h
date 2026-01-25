class CDOTA_Modifier_Item_PyrrhicCloak : public CDOTA_Buff
{
	float32 damage_pct;
	float32 max_distance;
	CHandle< CBaseEntity > m_hTarget;
	int32 m_nBuffSerialNumber;
};
