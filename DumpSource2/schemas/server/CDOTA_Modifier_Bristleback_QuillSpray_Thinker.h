class CDOTA_Modifier_Bristleback_QuillSpray_Thinker : public CDOTA_Buff
{
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CUtlVector< CHandle< CBaseEntity > > m_entitiesHit;
	CountdownTimer m_ViewerTimer;
	int32 projectile_speed;
	float32 radius;
	bool m_bTriggeredByBristleback;
	bool m_bDelayed;
	int32 m_nAngleRestriction;
	Vector m_vFacing;
}
