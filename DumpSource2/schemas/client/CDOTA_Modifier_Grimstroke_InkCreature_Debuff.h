class CDOTA_Modifier_Grimstroke_InkCreature_Debuff : public CDOTA_Buff
{
	float32 m_flCurrentArmorReduction;
	CHandle< C_BaseEntity > m_hLatchedCreature;
	float32 tick_interval;
	int32 damage_per_second;
}
