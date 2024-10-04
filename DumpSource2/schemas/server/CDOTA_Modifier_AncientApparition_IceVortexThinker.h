class CDOTA_Modifier_AncientApparition_IceVortexThinker : public CDOTA_Buff
{
	float32 radius;
	int32 movement_speed_pct;
	int32 spell_resist_pct;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_hChilledEntities;
}
