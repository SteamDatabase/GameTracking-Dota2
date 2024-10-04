class CDOTA_Modifier_MonkeyKing_Transform : public CDOTA_Buff
{
	CUtlString m_strDisguise;
	int32 movespeed;
	int32 m_nDisguisedSpeed;
	int32 reveal_radius;
	ParticleIndex_t m_nDisguiseEffectIndex;
	CHandle< CBaseEntity > m_hCourierToClone;
	CHandle< CBaseEntity > m_hCreepToClone;
	CUtlVector< CHandle< CBaseEntity > > m_aryBountyRuneSpawners;
	bool m_bIsFlyingCourier;
	bool m_bIsRune;
	bool m_bIsBanana;
	bool m_bIsFakeAlly;
	uint32 m_nMischiefUnitType;
	int32 m_nMischiefHealthbarOffset;
	float32 invul_duration;
};
