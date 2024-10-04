class CDOTA_Modifier_Grimstroke_InkCreature_Latched : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hAttachTarget;
	float32 m_fZOffset;
	bool m_bRemovedByEnemy;
	float32 latch_duration;
	int32 pop_damage;
	int32 latched_unit_offset;
	int32 latched_unit_offset_short;
}
