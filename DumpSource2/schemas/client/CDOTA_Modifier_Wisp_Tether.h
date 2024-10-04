class CDOTA_Modifier_Wisp_Tether : public CDOTA_Buff
{
	bool m_bInManaGained;
	CHandle< C_BaseEntity > m_hTarget;
	CUtlVector< CHandle< C_BaseEntity > > hStunnedEntities;
	float32 stun_duration;
	int32 movespeed;
	int32 self_bonus;
	bool m_bIsInRange;
	int32 radius;
	int32 latch_distance;
	int32 damage_absorb;
	float32 m_flHealthHealed;
	float32 m_flManaHealed;
	float32 tether_heal_amp;
	float32 tether_mana_amp;
	GameTime_t m_flHealMessageTime;
	GameTime_t m_flManaMessageTime;
};
