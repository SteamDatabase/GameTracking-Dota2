class CDOTA_Modifier_Zuus_Lightning_Hands : public CDOTA_Buff
{
	CUtlVector< int16 > m_InFlightAttackRecords;
	ParticleIndex_t m_nFXIndex;
	int32 arc_lightning_damage_pct;
	int32 arc_lightning_damage_illusion_pct;
	int32 attack_speed_bonus;
}
