class CDOTA_Modifier_Kez_RavensVeil_Thinker
{
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CUtlVector< CHandle< CBaseEntity > > m_entitiesHit;
	CountdownTimer m_ViewerTimer;
	float32 blast_radius;
	float32 blast_speed;
	int32 apply_parry_bonus;
	float32 blind_duration;
	float32 vuln_duration;
	Vector m_vStartLoc;
};
