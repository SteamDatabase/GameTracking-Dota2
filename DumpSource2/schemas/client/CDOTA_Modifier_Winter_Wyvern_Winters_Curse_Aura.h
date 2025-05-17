class CDOTA_Modifier_Winter_Wyvern_Winters_Curse_Aura : public CDOTA_Buff
{
	CHandle< C_BaseEntity > m_hTarget;
	int32 m_nAlliesTaunted;
	bool m_bRelicTriggered;
	float32 radius;
	int32 damage_reduction;
	GameTime_t m_flLastSeen;
	bool transfer_on_death;
	CUtlVector< CHandle< C_BaseEntity > > m_vhAffectedEnemyHeroes;
};
