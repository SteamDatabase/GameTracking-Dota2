class CDOTA_Modifier_LootDrop_Thinker : public CDOTA_Buff
{
	bool m_bAutoPickup;
	bool m_bOnlyPlayerHeroPickup;
	bool m_bCreepHeroPickup;
	bool m_bAutoUse;
	bool m_bFlying;
	bool m_bUseSpawnAnim;
	bool m_bAutoTeleport;
	GameTime_t m_flKnockbackStartTime;
	GameTime_t m_flKnockbackEndTime;
	float32 m_flKnockbackHeight;
	float32 m_flInitialHeight;
	float32 m_flKnockbackDuration;
	float32 m_flEndHeight;
	Vector m_vStartPos;
	Vector m_vEndPos;
	float32 m_fPickupRadius;
	CUtlString m_strTransitionEffect;
};
