class CDOTA_Modifier_Zuus_ThundergodsWrathThinker : public CDOTA_Buff
{
	int32 damage;
	float32 damage_pct;
	float32 sight_duration;
	float32 growing_delay;
	float32 grow_kill_amp;
	bool m_bZeusHasArcana;
	CUtlVector< CHandle< CBaseEntity > > m_hTargetEntities;
	int32 m_nFarKills;
	int32 m_nKills;
};
