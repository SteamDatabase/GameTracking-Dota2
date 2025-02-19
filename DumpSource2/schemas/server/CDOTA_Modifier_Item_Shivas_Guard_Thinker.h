class CDOTA_Modifier_Item_Shivas_Guard_Thinker
{
	float32 m_fCurRadius;
	GameTime_t m_fLastThink;
	CUtlVector< CHandle< CBaseEntity > > m_entitiesHit;
	CountdownTimer m_ViewerTimer;
	int32 blast_speed;
	float32 blast_radius;
	int32 blast_damage;
	int32 illusion_multiplier_pct;
	float32 blast_debuff_duration;
	float32 resist_debuff_duration;
};
