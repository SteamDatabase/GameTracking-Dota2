class CDOTA_Ability_Magnataur_Shockwave
{
	ParticleIndex_t m_nFXIndex;
	int32 m_nReturnDamagePct;
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitList;
	CUtlVector< CHandle< C_BaseEntity > > hAlreadyHitListReturning;
};
