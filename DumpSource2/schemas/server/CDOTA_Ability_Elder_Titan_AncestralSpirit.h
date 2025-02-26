class CDOTA_Ability_Elder_Titan_AncestralSpirit
{
	float32 speed;
	float32 radius;
	float32 buff_duration;
	float32 spirit_duration;
	int32 m_nCreepsHit;
	int32 m_nHeroesHit;
	bool m_bIsReturning;
	CHandle< CBaseEntity > m_hAncestralSpirit;
	ParticleIndex_t m_nReturnFXIndex;
	CUtlString m_strMoveSpiritSwapAbility;
};
