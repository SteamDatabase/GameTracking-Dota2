class C_DOTA_Ability_Elder_Titan_AncestralSpirit : public C_DOTABaseAbility
{
	int32 speed;
	int32 radius;
	float32 buff_duration;
	float32 spirit_duration;
	int32 m_nCreepsHit;
	int32 m_nHeroesHit;
	bool m_bIsReturning;
	CHandle< C_BaseEntity > m_hAncestralSpirit;
	ParticleIndex_t m_nReturnFXIndex;
	CUtlString m_strMoveSpiritSwapAbility;
}
