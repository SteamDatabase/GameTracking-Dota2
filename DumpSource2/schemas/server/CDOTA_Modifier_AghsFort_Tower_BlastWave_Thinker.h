class CDOTA_Modifier_AghsFort_Tower_BlastWave_Thinker : public CDOTA_Buff
{
	float32 damage_pct;
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CountdownTimer m_ViewerTimer;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > > m_EntitiesHit;
	int32 speed;
	int32 radius;
}
