class CDOTA_Modifier_Weaver_Shukuchi : public CDOTA_Modifier_Invisible
{
	float32 radius;
	int32 damage;
	int32 speed;
	int32 min_movespeed_override;
	float32 geminate_attack_mark_duration;
	float32 slow_duration;
	CUtlVector< CHandle< CBaseEntity > > m_hEntitiesAffected;
}
