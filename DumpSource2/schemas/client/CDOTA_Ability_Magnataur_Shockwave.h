class CDOTA_Ability_Magnataur_Shockwave : public C_DOTABaseAbility
{
	ParticleIndex_t m_nFXIndex;
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitList;
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitListReturning;
}
