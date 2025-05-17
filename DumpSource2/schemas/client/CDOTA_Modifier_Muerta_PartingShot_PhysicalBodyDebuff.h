class CDOTA_Modifier_Muerta_PartingShot_PhysicalBodyDebuff : public CDOTA_Modifier_Stunned
{
	CHandle< C_BaseEntity > m_hSoulEntityClient;
	int32 damage_reduction_percent;
};
