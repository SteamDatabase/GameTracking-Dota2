class CMatch3HeroDefinition
{
	HeroID_t m_nHeroID;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeCModel > > m_sPieceModel;
	CResourceNameTyped< CWeakHandle< InfoForResourceTypeIParticleSystemDefinition > > m_sAttackParticleEffect;
	CUtlString m_sSuperAbility;
	CUtlString m_sUltraAbility;
};
