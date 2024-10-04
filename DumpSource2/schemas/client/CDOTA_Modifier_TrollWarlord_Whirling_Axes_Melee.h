class CDOTA_Modifier_TrollWarlord_Whirling_Axes_Melee : public CDOTA_Buff
{
	int32 damage;
	int32 hit_radius;
	int32 axe_movement_speed;
	float32 whirl_duration;
	float32 max_range;
	float32 blind_duration;
	float32 m_flRotation;
	float32 m_flAxeRadius;
	GameTime_t m_flWhirlDieTime;
	float32 m_bPiercesMagicImmunity;
	int32 m_nSwapIndex;
	bool m_bReturning;
	ParticleIndex_t[2] m_nAxeFXIndex;
	int32 m_nHeroesHitForRelic;
	CUtlVector< CHandle< C_BaseEntity > > hitEntities;
	CUtlVector< CHandle< C_BaseEntity > > m_hAxes;
}
