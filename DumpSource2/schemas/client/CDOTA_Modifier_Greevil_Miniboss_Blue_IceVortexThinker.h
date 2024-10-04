class CDOTA_Modifier_Greevil_Miniboss_Blue_IceVortexThinker : public CDOTA_Buff
{
	float32 radius;
	int32 movement_speed_pct;
	int32 spell_resist_pct;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > m_hChilledEntities;
}
