class CDOTA_Modifier_Elder_Titan_AncestralSpirit : public CDOTA_Buff
{
	float32 pass_damage;
	float32 radius;
	int32 controllable;
	int32 m_nCreepsHit;
	int32 m_nHeroesHit;
	float32 m_flSpeed;
	CUtlVector< CHandle< CBaseEntity > > m_hHitUnits;
	Vector m_vCasterStartPosition;
	Vector m_vSpiritStartPosition;
	int32 m_nBonusMoveSpeed;
};
