class CDOTA_Modifier_Item_Veil_Of_Discord_Thinker : public CDOTA_Buff
{
	ParticleIndex_t m_nFXIndex;
	float32 debuff_radius;
	float32 resist_debuff_duration;
	int32 m_nHeroesHit;
	bool m_bHitInvisibleHero;
	bool m_bFirstPulse;
};
