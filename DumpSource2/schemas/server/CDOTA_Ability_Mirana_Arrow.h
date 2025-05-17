class CDOTA_Ability_Mirana_Arrow : public CDOTABaseAbility
{
	CHandle< CDOTABaseAbility > m_hSourceAbility;
	float32 scepter_radius;
	Vector m_vStartPos;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< CBaseEntity > >[2] hAlreadyHitList;
	CUtlVector< CHandle< CBaseEntity > >[2] hStarfallList;
	int32 m_nActiveArrow;
};
