class CDOTA_Modifier_TrollWarlord_Whirling_Axes_Melee
{
	float32 damage;
	float32 hit_radius;
	float32 axe_movement_speed;
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
	CUtlVector< CHandle< CBaseEntity > > hitEntities;
	CUtlVector< CHandle< CBaseEntity > > m_hAxes;
};
