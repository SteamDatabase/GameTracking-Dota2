class CDOTA_Modifier_Terrorblade_Metamorphosis_Fear_Thinker : public CDOTA_Buff
{
	float32 m_fLastRadius;
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > m_EntitiesHit;
	int32 scepter_speed;
	int32 scepter_radius;
	float32 damage;
	bool m_bFirstThink;
}
