class CDOTA_Modifier_Skywrath_Mage_Shield_Barrier : public CDOTA_Buff
{
	int32 m_nDamageAbsorbed;
	float32 damage_barrier_base;
	float32 damage_barrier_per_level;
	CUtlVector< GameTime_t > m_flExpirationTimes;
}
