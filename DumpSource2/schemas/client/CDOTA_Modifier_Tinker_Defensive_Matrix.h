class CDOTA_Modifier_Tinker_Defensive_Matrix : public CDOTA_Buff
{
	int32 damage_absorb;
	int32 status_resistance;
	int32 cooldown_reduction;
	int32 flicker_range;
	int32 flicker_angle;
	bool m_bStartedTimer;
	int32 m_nDamageAbsorbed;
}
