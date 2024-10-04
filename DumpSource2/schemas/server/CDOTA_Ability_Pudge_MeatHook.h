class CDOTA_Ability_Pudge_MeatHook : public CDOTABaseAbility
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
	ParticleIndex_t m_iSecondaryChainParticle;
	int32 m_hHookProjectile;
	int32 m_nManaCost;
	CHandle< CBaseEntity > m_hSourceCaster;
	int32 m_nNextConsecutiveHitCount;
	Vector m_vEndpoint;
	int32 m_nConsecutiveHits;
	bool m_bIsVectorTargeted;
	Vector m_vTurnLocation;
	Vector m_vDirectionAfterTurn;
	bool m_bHasTurned;
	float32 m_flDistanceAfterTurn;
	Vector m_vFinalPosition;
	float32 reveal_duration;
	int32 curve_hook;
	float32 curve_hook_turn_rate;
	int32 curve_hook_debug;
	float32 m_fTimeRemaining;
	float32 m_flFacingTarget;
}
