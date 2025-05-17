class CDOTA_Modifier_Aghsfort_Elemental_Wisp_Tether : public CDOTA_Buff
{
	bool m_bInManaGained;
	CHandle< CBaseEntity > m_hTarget;
	CUtlVector< CHandle< CBaseEntity > > hStunnedEntities;
	float32 slow_duration;
	int32 movespeed;
	int32 self_bonus;
	bool m_bIsInRange;
	int32 radius;
	int32 latch_distance;
	float32 m_flHealthHealed;
	float32 m_flManaHealed;
	float32 tether_heal_amp;
	GameTime_t m_flHealMessageTime;
	GameTime_t m_flManaMessageTime;
};
