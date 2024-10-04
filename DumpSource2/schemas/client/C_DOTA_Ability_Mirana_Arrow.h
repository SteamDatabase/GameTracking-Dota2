class C_DOTA_Ability_Mirana_Arrow : public C_DOTABaseAbility
{
	int32 scepter_radius;
	Vector m_vStartPos;
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > >[2] hAlreadyHitList;
	CUtlVector< CHandle< C_BaseEntity > >[2] hStarfallList;
	int32 m_nActiveArrow;
}
