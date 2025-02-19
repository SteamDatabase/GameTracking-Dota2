class CDOTA_Ability_Aghsfort_Bonus_Pudge_MeatHook
{
	Vector m_vProjectileLocation;
	float32 hook_speed;
	int32 hook_width;
	int32 hook_distance;
	bool m_bRetracting;
	bool m_bDiedInHook;
	CHandle< CBaseEntity > m_hVictim;
	Vector m_vTargetPosition;
	Vector m_vCasterPosition;
	bool m_bChainDetached;
	ParticleIndex_t m_iChainParticle;
	int32 m_iHookParticle;
	int32 m_nManaCost;
	CHandle< CBaseEntity > m_hSourceCaster;
	int32 m_nNextConsecutiveHitCount;
	int32 m_nConsecutiveHits;
};
