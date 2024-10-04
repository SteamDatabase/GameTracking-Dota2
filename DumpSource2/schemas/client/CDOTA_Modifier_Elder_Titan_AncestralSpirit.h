class CDOTA_Modifier_Elder_Titan_AncestralSpirit : public CDOTA_Buff
{
	int32 pass_damage;
	int32 radius;
	int32 controllable;
	int32 m_nCreepsHit;
	int32 m_nHeroesHit;
	float32 m_flSpeed;
	CUtlVector< CHandle< C_BaseEntity > > m_hHitUnits;
	Vector m_vCasterStartPosition;
	Vector m_vSpiritStartPosition;
	int32 m_nBonusMoveSpeed;
};
